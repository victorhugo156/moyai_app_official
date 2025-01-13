import { NextFunction, Request, Response } from "express";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import {
  generateAccessToken,
  generateRefreshToken,
  Role,
  verifyAccessToken,
  verifyRefreshToken,
} from "../../utils/JsonWebTokenGenerator.js";
import { Token } from "aws-sdk";
import { RefreshToken } from "../../db/entities/RefreshToken.js";
import { User } from "../../db/entities/User.js";

export const verifyLoginStatus = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1]; // Extract token part

  try {
    if (!token) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Access token missing");
    }

    const isAuthorized = await verifyAccessToken(token);
    

    if (!isAuthorized) {
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Invalid or Expired token"
      );
    }

    next();
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
      res
        .status(StatusCode.UNAUTHORIZED)
        .json(
          new ApiError(StatusCode.UNAUTHORIZED, error, "Something went wrong")
        );
    }
  }
};

export const refreshToken = async (
  req: Request<{}, {}, { refreshToken: string }>,
  res: Response
) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Refresh token missing");
    }

    const user = verifyRefreshToken(refreshToken);

    if (!user) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User not found");
    }

    const jti = user.jti;
    const userId = user.userId;
    const searchedToken = await RefreshToken.findOne({
      where: { jti: jti },
      relations: ["user"],
    });

    console.log("Second");
    console.log(searchedToken);

    if (!searchedToken) {
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Couldn't find the jti in the Refresh Token table"
      );
    }

    console.log(searchedToken, userId);

    if (searchedToken.user.userId != userId)
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Credentials doesn't match"
      );
    const newAccessToken = generateAccessToken(user.userId, Role.USER);
    // it returns an array
    // index [0] is token
    // index [1] is jti
    const newRefreshToken = generateRefreshToken(userId);

    console.log("third");
    console.log(newAccessToken);
    const newGeneratedRefreshToken = newRefreshToken[0];
    const newEntryToken = RefreshToken.create({
      jti: newRefreshToken[1],
      user: searchedToken.user,
    });
    const newSavedToken = await newEntryToken.save();

    if (!newSavedToken)
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "Unable to save new refresh token"
      );

    await searchedToken.remove();
    res.status(StatusCode.OK).json(
      new ApiResponse(StatusCode.CREATED, {
        accessToken: newAccessToken,
        refreshToken: newGeneratedRefreshToken,
      })
    );
  } catch (error) {
    console.error(error); // Log the error for debugging
    res.status(StatusCode.UNAUTHORIZED).json(error);
  }
};

// todo :: remove token from database after expiry time
