import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { asyncHandler } from "../../utils/AsyncHandler.js";
import { Request, response, Response } from "express";
import bcrypt from "bcrypt";
import { Jwt } from "jsonwebtoken";
import {
  generateAccessToken,
  generateRefreshToken,
  Role,
  verifyAccessToken,
} from "../../utils/JsonWebTokenGenerator.js";
import {
  validatePasswordSecurity,
  checkPassword,
  checkPhoneNumberValidity,
  validateEmail,
  validatePhoneNumber,
} from "./userControllerHelper.js";
import { User } from "../../db/entities/User.js";
import { RefreshToken } from "../../db/entities/RefreshToken.js";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import { randomBytes } from "crypto";
import NodeCache from "node-cache";
import { UserProfileQuestion } from "../../db/entities/UserProfileQuestion.js";

// this will hold the verification code for 5 mins for each user.
// which will then be deleted automatically.
const myCache = new NodeCache({ stdTTL: 300 }); // 300 seconds

// Define a intrface for the request body
interface ReqUserData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  phoneNumber: string;
}

export const verificationCode = async (
  req: Request<{}, {}, { email: string }>,
  res: Response
): Promise<void> => {
  try {
    const { email } = req.body;

    const valid = validateEmail(email);
    if (!valid) throw new ApiError(400, {}, "Invalid Email Address");
    // Ensure email is provided
    if (!email) {
      throw new ApiError(400, {}, "Email is required!");
    }

    // Setup SES client
    const sesClient = new SESClient({
      region: "ap-southeast-2",
      credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID || "",
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || "",
      },
    });

    // Generate a 6-character verification code
    const generateVerificationCode = (): string =>
      randomBytes(3).toString("hex").toUpperCase().slice(0, 6);

    // Send verification email
    const sendVerificationEmail = async (toEmail: string): Promise<void> => {
      const verificationCode = generateVerificationCode();

      const emailParams = {
        Destination: { ToAddresses: [toEmail] },
        Message: {
          Body: {
            Text: {
              Data: `Dear User,Your verification code is: ${verificationCode} This code is valid for 5 minutes. \nIf you did not request this code, please ignore this email. \n\nThank you, \nMoyai Team
              `,
            },
          },
          Subject: { Data: "Verification Code" },
        },
        Source: process.env.FROM_EMAIL_SOURCE, // Ensure this is a verified sender email
      };

      const sendEmailCommand = new SendEmailCommand(emailParams);
      const response = await sesClient.send(sendEmailCommand);

      if (!sendEmailCommand)
        throw new ApiError(
          400,
          {},
          "Unable to send email. Please try again later."
        );

      const cache = myCache.set(email, verificationCode);
      if (!cache)
        throw new ApiError(
          400,
          {},
          "something went wrong while generating the code."
        );
      console.log("Email sent successfully:", response);
    };

    await sendVerificationEmail(email);

    res.status(200).json(new ApiResponse(200, {}, "Email sent successfully"));
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res.status(500).json({ success: false, error: "Failed to send email" });
    }
  }
};

export const validateVerificationCode = async (
  req: Request<{}, {}, { code: string; email: string }>,
  res: Response
): Promise<void> => {
  try {
    const { code, email } = req.body;

    if (!code || !email)
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Missing verification code or Email."
      );
    const savedCode: string = myCache.get(email) || "";

    if (savedCode.toLowerCase() !== code.toLowerCase())
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Incorrect Verification Code."
      );
    else {
      myCache.del(email);
      res
        .status(StatusCode.OK)
        .json(new ApiResponse(StatusCode.OK, {}, "Verified successfully"));
    }
  } catch (error) {
    if (error instanceof ApiError) res.status(error.statusCode).json(error);
    else {
      // Handle unexpected errors
      console.error(error); // Log the error for debugging
      res.status(500).json(new ApiError(500, error, "Internal Server Error"));
    }
    return;
  }
};

export const registerUser = async (
  req: Request<{}, {}, ReqUserData>,
  res: Response
): Promise<void> => {
  const { firstName, lastName, email, password, phoneNumber } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    // if any of these field is empty it will send a response of 404 error.
    if (!email || !password || !firstName || !lastName || !phoneNumber) {
      throw new ApiError(
        400,
        {},
        "Please make sure all field have values on them"
      );
    }

    // this function check if the email is valid
    if (!validateEmail(email)) {
      throw new ApiError(400, {}, "Email is not valid");
    }

    // checks password length and if it is strong
    if (!validatePasswordSecurity(password)) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Password is not secured enough. See if it has at least 8 characters and at lease one capital letter, small letter, symbol and a number"
      );
    }

    // check if the phoneNumber is valid
    // Must start with +61, should be 12 characters long including countrycode.
    // currently supports only australia
    const isPhoneValid = validatePhoneNumber(phoneNumber);
    if (!isPhoneValid)
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Invalid Phone Number");

    // check if the user with this email already exists
    const checkUserEmail = await User.findOne({ where: { email } });

    if (checkUserEmail != null) {
      throw new ApiError(StatusCode.CONFLICT, {}, "User already Registered");
    }

    // check if the user with this phone Number already exists
    const checkUserPhone = await User.findOne({ where: { phoneNumber } });
    if (checkUserPhone != null) {
      console.log(checkUserPhone);
      throw new ApiError(StatusCode.CONFLICT, {}, "Phone Number already used");
    }

    // create a user

    const newUser = User.create({
      firstName,
      lastName,
      email,
      password: hashedPassword,
      phoneNumber: phoneNumber.toString(),
    });

    const savedUser = await newUser.save();
    if (!savedUser)
      throw new ApiError(
        StatusCode.INTERNAL_SERVER_ERROR,
        {},
        "Failed to register User"
      );
    const profileQuestions = UserProfileQuestion.create({
      foodIntolerances: false,
      overwhelmedByNoiseOrLight: false,
      hasInvisibleDisability: false,
      mobilityAidUsage: false,
      userId: newUser.userId,
    });

    const savedProfileQuestions = await profileQuestions.save();
    if (!savedProfileQuestions)
      throw new ApiError(
        StatusCode.INTERNAL_SERVER_ERROR,
        {},
        "Unable to add default user preference."
      );
  } catch (error) {
    if (error instanceof ApiError)
      res
        .status(error.statusCode)
        .json(
          new ApiError(
            error.statusCode,
            {},
            error.message || "Something is not right"
          )
        );
    else {
      // Handle unexpected errors
      console.error(error); // Log the error for debugging
      res.status(500).json(new ApiError(500, error, "Internal Server Error"));
    }
    return;
  }
  res.status(StatusCode.OK).json(
    new ApiResponse(StatusCode.OK, {
      firstName,
      lastName,
      email,
      phoneNumber,
    })
  );
};

// This fun login user and generate a refresh and access token if the email and password user input matched the hashed password for that user.
export const loginUser = async (
  req: Request<{}, {}, { email: string; password: string }>,
  res: Response
): Promise<void> => {
  const { email, password } = req.body;

  // check if the email is an valid email

  try {
    if (!email || !password) {
      // returns true only when the email is a valid email
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Email or password cannot be empty!"
      );
    }
    const lowerCasedEmail = email.toLowerCase();

    if (lowerCasedEmail) {
      // returns true only when the email is a valid email
      if (!validateEmail(lowerCasedEmail)) {
        throw new ApiError(
          StatusCode.BAD_REQUEST,
          {},
          "Input email is not valid"
        );
      }
    }

    // search for the user using email in the database
    const searchedUser = await User.findOne({
      where: { email: lowerCasedEmail },
      relations: ["userProfileQuestion"],
    });

    if (!searchedUser) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User Not Found");
    }

    // compare hashed password and the user input password for that user
    const isPasswordValid = await checkPassword(
      password,
      searchedUser.password
    );

    if (!isPasswordValid) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Invalid Password");
    }

    // if the password and hashed password match, then generate an access and refresh token

    const accessToken = generateAccessToken(searchedUser.userId, Role.USER);

    // generate refresh token returns an array
    // storing that array into a new constant variable
    const genetated = generateRefreshToken(searchedUser.userId);
    // refresh token is returned at index 0 & jti at 1.
    const refreshToken = genetated[0];
    const jti = genetated[1];

    const tokenTable = RefreshToken.create({
      user: searchedUser,
      jti: jti,
    });

    tokenTable.save();

    if (!tokenTable) {
      throw new ApiError(
        StatusCode.INTERNAL_SERVER_ERROR,
        {},
        "Unable to store token in the db."
      );
    }

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          accessToken,
          refreshToken,
          userPreferences: searchedUser.userProfileQuestion,
        },
        "User Logged In Successfully"
      )
    );
  } catch (error) {
    if (error instanceof ApiError)
      res
        .status(error.statusCode)
        .json(
          new ApiError(
            error.statusCode,
            {},
            error.message || "Something is not right"
          )
        );
    else {
      // Handle unexpected errors
      console.error(error); // Log the error for debugging
      res.status(500).json(new ApiError(500, error, "Internal Server Error"));
    }
    return;
  }
};

export const getCurrentUserDetails = async (req: Request, res: Response) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  try {
    const decodedToken = verifyAccessToken(token || "");

    if (!decodedToken)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Access token Expired.");

    const user = await User.findOne({
      where: { userId: decodedToken?.userId },
      relations: ["userProfileQuestion"],
    });
    if (!user)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User not found");
    else {
      const { password, ...userWithoutPassword } = user;
      res
        .status(StatusCode.OK)
        .json(
          new ApiResponse(
            StatusCode.OK,
            userWithoutPassword,
            "Successfully fetcted user data"
          )
        );
    }
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_REQUEST)
        .json(
          new ApiError(
            StatusCode.BAD_REQUEST,
            error,
            "SOmething went wrong when fetching user info"
          )
        );
    }
  }
};

export const editCurrentUserDetail = async (
  req: Request<
    {},
    {},
    { password: string; editType: PersonalInfoEnum; newDetail: string }
  >,
  res: Response
) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  const { password, editType, newDetail } = req.body;
  try {
    if (!token) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Missing Token.");
    }
    if (!editType || !newDetail) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Missing, What field do you want to update?"
      );
    }
    if (!Object.values(PersonalInfoEnum).includes(editType)) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Invalid Edit Type");
    }

    if (!password) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Missing Password");
    }

    const decodedToken = verifyAccessToken(token || "");

    if (!decodedToken)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Access token Expired.");

    const user = await User.findOne({
      where: { userId: decodedToken?.userId },
    });

    if (!user) throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    const verifyPassword = await checkPassword(password, user?.password || "");

    if (!verifyPassword) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Incorrect Credencial");
    }

    switch (editType) {
      case PersonalInfoEnum.FULLNAME:
        const name = newDetail.split(" ");

        if (user.firstName == name[0] && user.lastName == name[1]) {
          throw new ApiError(
            StatusCode.UNAUTHORIZED,
            {},
            "Same details cannot be changed."
          );
        }
        if (user.firstName != name[0]) {
          user.firstName = name[0];
        }
        if (user.lastName != name[1]) {
          user.lastName = name[1];
        }
        const savedUser = await user.save();

        if (!savedUser) {
          throw new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wring while saving this information."
          );
        }
        break;

      case PersonalInfoEnum.PASSWORD:
        const hashedPassword = await bcrypt.hash(newDetail, 10);
        user.password = hashedPassword;
        const passSavedUser = await user.save();
        if (!passSavedUser) {
          throw new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wring while saving this information."
          );
        }
        break;

      case PersonalInfoEnum.PHONE:
        const validPhone = validatePhoneNumber(newDetail);
        if (!validPhone) {
          throw new ApiError(
            StatusCode.BAD_REQUEST,
            {},
            "Phone Number is not valid"
          );
        }
        user.phoneNumber = newDetail;
        const phoneSavedUser = await user.save();
        if (!phoneSavedUser) {
          throw new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong while saving this information."
          );
        }
        break;

      case PersonalInfoEnum.DOB:
        if (typeof newDetail !== "string" || !isValidDateString(newDetail)) {
          throw new ApiError(
            StatusCode.BAD_REQUEST,
            {},
            "Invalid date format. Please use YYYY-MM-DD."
          );
        }
        const dateOfBirth = new Date(newDetail);

        console.log(dateOfBirth);
        console.log(newDetail);

        if (isNaN(dateOfBirth.getTime())) {
          throw new ApiError(StatusCode.BAD_REQUEST, {}, "Invalid Date");
        }

        user.dob = dateOfBirth;
        const savedDobUser = await user.save();
        if (!savedDobUser) {
          throw new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong while saving this information."
          );
        }

        break;
    }

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(StatusCode.OK, editType + " changed successfully.")
      );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_REQUEST)
        .json(
          new ApiError(
            StatusCode.BAD_REQUEST,
            error,
            "Something went wrong while fetching user info"
          )
        );
    }
  }
};

enum PersonalInfoEnum {
  FULLNAME = "fullName",
  LASTNAME = "lastName",
  PHONE = "phone",
  DOB = "dob",
  PERSONALIZATION = "personalization",
  PROFILEIMAGE = "profileImage",
  PASSWORD = "password",
}

function isValidDateString(dateString: string): boolean {
  // Regular expression to match YYYY-MM-DD format
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

  if (!dateRegex.test(dateString)) return false;

  // Ensure the date is valid
  const date = new Date(dateString);
  const [year, month, day] = dateString.split("-").map(Number);

  return (
    date.getFullYear() === year &&
    date.getMonth() + 1 === month &&
    date.getDate() === day
  );
}
