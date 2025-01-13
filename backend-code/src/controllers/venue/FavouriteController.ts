import { Request, Response } from "express";
import {
  AccessTokenPayload,
  verifyAccessToken,
} from "../../utils/JsonWebTokenGenerator.js";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { User } from "../../db/entities/User.js";
import { Venue } from "../../db/entities/Venue.js";
import { Favorite } from "../../db/entities/Favourites.js";

export const addToFavourite = async (
  req: Request<{}, {}, {}, { venueId: string }>,
  res: Response
) => {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1]; // Extract token part
    const venueId = req.query.venueId;

    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!token) {
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "AccessToken not provided"
      );
    }

    const decodedToken = verifyAccessToken(token || "");
    console.log(decodedToken);

    if (!decodedToken) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User is not authorized");
    }

    const userId = decodedToken.userId;
    console.log(userId);
    const user = await User.findOne({ where: { userId: userId } });
    console.log(user);
    // search for user
    if (!user) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    }
    // search for venue
    const venue = await Venue.findOne({ where: { venueId } });

    console.log(venueId);
    console.log(venue);

    if (!venue) {
      console.log("Something is wrong?");

      throw new ApiError(StatusCode.NOT_FOUND, {}, "Venue not found");
    }

    const checkIfAlreadyInFav = await Favorite.findOne({
      where: { venue, user },
    });

    if (checkIfAlreadyInFav) {
      throw new ApiError(StatusCode.CONFLICT, {}, "Already in favourites");
    }

    const newFav = Favorite.create({ user: user, venue: venue });
    const savedFav = await newFav.save();

    if (!savedFav) {
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "Unable to add to favourites"
      );
    }

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(StatusCode.OK, {}, "Successfully added to favourites")
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

export const removeFromFavoutite = async (
  req: Request<{}, {}, {}, { venueId: string }>,
  res: Response
) => {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1]; // Extract token part
    const venueId = req.query.venueId;
    if (!venueId || !token) {
      throw new ApiError(
        StatusCode.UNAUTHORIZED,
        {},
        "VenueId or AccessToken not provided"
      );
    }

    const decodedToken = verifyAccessToken(token || "");

    if (!decodedToken) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "User is not authorized");
    }

    const userId = decodedToken.userId;
    const user = await User.findOne({ where: { userId } });
    if (!user) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    }
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Venue not found");
    }

    console.log(venue);
    console.log(user);
    const inFav = await Favorite.findOne({
      where: { userId: user.userId, venueId: venue.venueId },
    });

    if (!inFav) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Not found in favourites");
    }

    const fav = Favorite.create({ user: user, venue: venue });
    const removeFav = await fav.remove();

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          {},
          "Successfully removed from favourites."
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

export const getAllFavourites = async (req: Request, res: Response) => {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1]; // Extract token part

    if (!token) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Token not found");
    }

    const decodedToken = verifyAccessToken(token || "") as AccessTokenPayload;
    if (!decodedToken) {
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "User not authorized! Invalid Token "
      );
    }

    const userId = decodedToken.userId;

    const user = await User.findOne({ where: { userId } });
    if (!user) throw new ApiError(StatusCode.NOT_FOUND, {}, "User now found");

    const fav = await Favorite.find({
      where: { userId: userId },
      relations: ["venue", "venue.coordinates"],
    });

    if (!fav)
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "Cannot find favourites for that user "
      );

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          favCount: fav.length,
          fav,
        },
        "Successfully fetched all favourites"
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

export const checkIfVenueIsInFav = async (req: Request, res: Response) => {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1]; // Extract token part
    const venueId: string = req.query.venueId as string;
    console.log(venueId); // This is now a string

    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!token) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Token not found");
    }

    const decodedToken = verifyAccessToken(token || "") as AccessTokenPayload;
    if (!decodedToken) {
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "User not authorized! Invalid Token "
      );
    }

    const userId = decodedToken.userId;

    const user = await User.findOne({ where: { userId } });
    if (!user) throw new ApiError(StatusCode.NOT_FOUND, {}, "User now found");

    const fav = await Favorite.findOne({
      where: { userId: userId, venueId: venueId },
    });

    console.log(fav);
    if (!fav) {
      res.status(StatusCode.OK).json(
        new ApiResponse(
          StatusCode.OK,
          {
            isInFav: false,
          },
          "Venue is not in favourites"
        )
      );
      return;
    } else {
      res.status(StatusCode.OK).json(
        new ApiResponse(
          StatusCode.OK,
          {
            isInFav: true,
          },
          "Venue is in favourites"
        )
      );
      return;
    }
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
