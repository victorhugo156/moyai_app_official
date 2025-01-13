import { Request, Response } from "express";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { verifyAccessToken } from "../../utils/JsonWebTokenGenerator.js";
import jwt from "jsonwebtoken";
import { json } from "stream/consumers";
import internal from "stream";
import { AccessorInformation } from "../../db/entities/AccessorInformation.js";
import { User } from "../../db/entities/User.js";

interface accessorInfo {
  rightToWorkForm: string;
  trainingCompleted: boolean;
  trainingSuccessMarked: boolean;
}

interface DecodedAccessToken {
  userId: string;
  email: string;
  iat: number;
  exp: number;
}

export const registerAccessor = async (
  req: Request<{}, {}, accessorInfo>,
  res: Response
) => {
  const { rightToWorkForm, trainingCompleted, trainingSuccessMarked } =
    req.body;
  const accessToken = req.headers.authorization?.split(" ")[1]; // This gets the token after "Bearer "

  try {
    if (!accessToken) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Access Token not found");
    }

    // check if the access token is valid
    if (!verifyAccessToken(accessToken)) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Invalid Access Token");
    }

    // decrypt the access token
    const decodedToken = jwt.decode(accessToken) as DecodedAccessToken;
    // get userid from the access token

    const userId = decodedToken.userId;
    const email = decodedToken.email;

    // use the userId to register that user as a accessor
    const user = await User.findOne({ where: { userId } });
    if (!user) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    }

    // check if user is already an accesser

    const checkRegistered = await AccessorInformation.findOne({
      where: { user: user },
    });

    // if user is registered it throws an error
    if (checkRegistered) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "User already registered as accesser"
      );
    }

    // store the right to work form in the database

    // create a newAccessor and then store it into databse
    const newAccessor = new AccessorInformation();
    newAccessor.user = user;
    newAccessor.rightToWorkForm = "https://www.example.com"; // a default link for testing
    newAccessor.trainingCompleted = false;
    newAccessor.trainingSuccessMarked = false;

    await newAccessor.save();

    if (!newAccessor) {
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "Something went wrong while saving the Accessor to the database"
      );
    }

    // send success response
    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          decodedToken,
        },
        "Form submitted successfully. Please wait for the response from the team"
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
