import { Request, Response } from "express";
import { checkPassword, validateEmail } from "./userControllerHelper.js";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { Admin } from "../../db/entities/Admin.js";
import {
  generateAccessToken,
  generateRefreshToken,
  Role,
} from "../../utils/JsonWebTokenGenerator.js";
import { RefreshToken } from "../../db/entities/RefreshToken.js";
import { AdminRefreshToken } from "../../db/entities/AdminRefreshToken.js";

export const loginAdmin = async (
  req: Request<{}, {}, { email: string; password: string }>,
  res: Response
): Promise<void> => {
  const { email, password } = req.body;

  // check if the email is an valid email

  try {
    if (email) {
      // returns true only when the email is a valid email
      if (!validateEmail(email)) {
        throw new ApiError(
          StatusCode.BAD_REQUEST,
          {},
          "Input email is not valid"
        );
      }
    }

    // search for the user using email in the database
    const searchedAdmin = await Admin.findOne({ where: { email } });

    if (!searchedAdmin) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Admin Not Found");
    }

    // compare hashed password and the user input password for that user
    const isPasswordValid = await checkPassword(
      password,
      searchedAdmin.password
    );

    if (!isPasswordValid) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Invalid Password");
    }

    // if the password and hashed password match, then generate an access and refresh token

    const accessToken = generateAccessToken(searchedAdmin.userId, Role.ADMIN);

    // generate refresh token returns an array
    // storing that array into a new constant variable
    const genetated = generateRefreshToken(searchedAdmin.userId);
    // refresh token is returned at index 0 & jti at 1.
    const refreshToken = genetated[0];
    const jti = genetated[1];

    const tokenTable = AdminRefreshToken.create({
      admin: searchedAdmin,
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
