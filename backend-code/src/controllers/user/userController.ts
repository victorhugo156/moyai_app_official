import { Request, Response } from "express";
import { extractToken } from "../../utils/HelperFunctions.js";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { verifyAccessToken } from "../../utils/JsonWebTokenGenerator.js";
import { User } from "../../db/entities/User.js";
import {
  checkPassword,
  validatePasswordSecurity,
} from "../auth/userControllerHelper.js";
import bcrypt from "bcrypt";
import { uploadImage } from "../venue/fileController.js";
import { UserProfileQuestion } from "../../db/entities/UserProfileQuestion.js";

export const uploadProfileImage = async (req: Request, res: Response) => {
  try {
    const token = extractToken(req);
    const decodedToken = verifyAccessToken(token);
    const userId = decodedToken?.userId;
    if (!decodedToken) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "User not authenticated");
    }
    if (!userId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "UserID not provided");
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const user = await User.findOne({ where: { userId } });
    if (!user) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.USER_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    user.profileImage = imageUrl;
    await user.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          { userProfileImage: imageUrl },
          "Successful"
        )
      );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_REQUEST)
        .json(
          new ApiError(StatusCode.BAD_REQUEST, error, "Something went wrong")
        );
    }
    return;
  }
};

enum UpdateAccountDetailFieldName {
  FIRSTNAME = "firstName",
  LASTNAME = "lastName",
  PASSWORD = "password",
}

// change accunt details
export const updateAccountDetails = async (
  req: Request<
    {},
    {},
    {
      fieldName: UpdateAccountDetailFieldName;
      newDetail: string;
      password: string;
    }
  >,
  res: Response
) => {
  try {
    const { fieldName, newDetail, password } = req.body;

    if (!fieldName && !newDetail)
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "FieldName and Details should not be empty"
      );

    if (!Object.values(UpdateAccountDetailFieldName).includes(fieldName)) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Invalid field name");
    }
    const token = extractToken(req);
    if (token == "")
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "No token found");

    if (!password)
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Please enter your password"
      );

    const decodedToken = verifyAccessToken(token);
    if (!decodedToken)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Unable to decode");

    const userId = decodedToken.userId;
    const user = await User.findOne({ where: { userId } });
    if (!user)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User not found");

    const hashedPassword = user?.password;

    const isValidPass = await checkPassword(password, hashedPassword);

    if (!isValidPass)
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Password is not valid");

    if (fieldName === UpdateAccountDetailFieldName.FIRSTNAME) {
      user.firstName = newDetail;
    } else if (fieldName === UpdateAccountDetailFieldName.LASTNAME) {
      user.lastName = newDetail;
    } else if (fieldName === UpdateAccountDetailFieldName.PASSWORD) {
      const isSecured = validatePasswordSecurity(newDetail);
      console.log(isSecured);
      if (!isSecured)
        throw new ApiError(
          StatusCode.UNAUTHORIZED,
          {},
          "Not secured password, try again With at least 1 small letter , 1 capital letter , 1 number and a symbol"
        );

      const newHashedPassword = await bcrypt.hash(password, 10);
      user.password = newHashedPassword;
    }

    const savedUser = await user.save();
    if (!savedUser)
      throw new ApiError(
        StatusCode.INTERNAL_SERVER_ERROR,
        {},
        "Something went wrong "
      );

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.ACCEPTED,
          {},
          "Successfully changed " + fieldName
        )
      );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_REQUEST)
        .json(
          new ApiError(StatusCode.BAD_REQUEST, error, "Something went wrong")
        );
    }
  }
};

// // change accunt details
// const updatePhoneNumber = async (
//   req: Request<
//     {},
//     {},
//     {
//       phone: string;
//       password: string;
//     }
//   >,
//   res: Response
// ) => {
//   try {
//     const { phone, password } = req.body;
//     const token = extractToken(req);
//     if (token == "")
//       throw new ApiError(StatusCode.UNAUTHORIZED, {}, "No token found");

//     if (!password)
//       throw new ApiError(
//         StatusCode.UNAUTHORIZED,
//         {},
//         "Please enter your password"
//       );
//     if (!phone)
//       throw new ApiError(StatusCode.BAD_REQUEST, {}, "Phone cannot be empty");

//     const decodedToken = verifyAccessToken(token);
//     if (!decodedToken)
//       throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Unable to decode");

//     const userId = decodedToken.userId;
//     const user = await User.findOne({ where: { userId } });
//     if (!user)
//       throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User not found");

//     const hashedPassword = user?.password;
//     const isValidPass = await checkPassword(password, hashedPassword);

//     if (!isValidPass)
//       throw new ApiError(StatusCode.BAD_REQUEST, {}, "Password is not valid");
//   } catch (error) {}
// };

export const updateAccessibilityPreferance = async (
  req: Request<
    {},
    {},
    {
      hasMobilityIssue: boolean;
      hasInvisibleDisability: boolean;
      hasFoodIntolerance: boolean;
      overwhelmedNoiseLight: boolean;
    }
  >,
  res: Response
) => {
  try {
    const {
      hasMobilityIssue,
      hasInvisibleDisability,
      hasFoodIntolerance,
      overwhelmedNoiseLight,
    } = req.body;
    const token = extractToken(req);
    const decodeToken = verifyAccessToken(token);

    if (
      hasMobilityIssue === undefined ||
      hasInvisibleDisability === undefined ||
      hasFoodIntolerance === undefined ||
      overwhelmedNoiseLight === undefined
    )
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "Accessibility requirements cannot be null or undefined. Make sure you provide all information. "
      );
    console.log("1");

    if (!decodeToken)
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Token is Expired or invalid. "
      );

    // search the user
    const user = await User.findOne({
      where: { userId: decodeToken.userId },
      relations: ["userProfileQuestion"],
    });

    if (!user) throw new ApiError(StatusCode.NOT_FOUND, {}, "User Not found. ");
    console.log("3");

    // Check if the user already has related accessibility preferences
    let question = await UserProfileQuestion.findOne({
      where: { user: { userId: decodeToken.userId } },
    });

    if (!question) {
      // Create new preferences if none exist
      question = UserProfileQuestion.create({
        userId: decodeToken.userId,
        foodIntolerances: hasFoodIntolerance,
        overwhelmedByNoiseOrLight: overwhelmedNoiseLight,
        mobilityAidUsage: hasMobilityIssue,
        hasInvisibleDisability: hasInvisibleDisability,
      });

      const savedQuestion = await question.save();
      if (!savedQuestion) {
        throw new ApiError(
          StatusCode.INTERNAL_SERVER_ERROR,
          {},
          "Unable to save accessibility preferences."
        );
      }
    } else {
      // Update existing preferences
      question.mobilityAidUsage = hasMobilityIssue;
      question.overwhelmedByNoiseOrLight = overwhelmedNoiseLight;
      question.hasInvisibleDisability = hasInvisibleDisability;
      question.foodIntolerances = hasFoodIntolerance;

      const savedQuestion = await question.save();
      if (!savedQuestion) {
        throw new ApiError(
          StatusCode.INTERNAL_SERVER_ERROR,
          {},
          "Unable to save updated accessibility preferences."
        );
      }
    }

    // Save user data if needed (if there are user-specific changes)
    const savedUser = await user.save();
    if (!savedUser) {
      throw new ApiError(
        StatusCode.INTERNAL_SERVER_ERROR,
        {},
        "Unable to save the user data."
      );
    }

    // Respond with success
    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          {},
          "Accessibility preferences updated successfully."
        )
      );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_REQUEST)
        .json(
          new ApiError(StatusCode.BAD_REQUEST, error, "Something went wrong")
        );
    }
  }
};
