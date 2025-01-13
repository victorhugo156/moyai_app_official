import { Request, Response } from "express";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { verifyAccessToken } from "../../utils/JsonWebTokenGenerator.js";
import { User } from "../../db/entities/User.js";
import { VenueReview } from "../../db/entities/VenueReview.js";
import { Venue } from "../../db/entities/Venue.js";
import { validate as isUuid } from "uuid";
import { extractToken } from "../../utils/HelperFunctions.js";

interface ReviewRequest {
  rating: number;
  reviewText: string;
  venueId: string;
}

export const leaveAReview = async (
  req: Request<{}, {}, ReviewRequest>,
  res: Response
) => {
  const { rating, reviewText, venueId } = req.body;

  // get the bearer token which holds the access token
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  try {
    // if token is missing send a Unauthorized response
    if (!token) {
      throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Missing Access token.");
    }

    // check if rating and review are empty
    // they can never be empty. Sending a bad request response if they are empty
    if (!rating || !reviewText)
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Missing rating and review."
      );

    // if venueId is missing send a bad request
    if (!venueId)
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Missing venueId");

    if (!isUuid(venueId)) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Invalid UUID - VenueId");
    }

    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue)
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Cant find the Venue");

    // this will decode the token, which stores user id.
    const decodeToken = verifyAccessToken(token);

    const user = await User.findOne({ where: { userId: decodeToken?.userId } });

    // check for the user id in the database.
    // if the id is not found it will send a not found response
    if (!user) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    }

    const findAnyReview = await VenueReview.findOne({
      where: { user: { userId: user.userId } },
    });

    if (findAnyReview)
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "An user can only have one review per venue."
      );

    const venueReview = VenueReview.create({
      reviewText,
      stars: rating,
      user: user,
      venue: { venueId },
    });

    const savedVenue = await venueReview.save();
    if (!savedVenue) {
      throw new ApiError(
        StatusCode.BAD_GATEWAY,
        {},
        "Unable to save the review. Try again later."
      );
    }
    res
      .status(StatusCode.CREATED)
      .json(
        new ApiResponse(StatusCode.CREATED, {}, "Review posted successfully")
      );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_GATEWAY)
        .json(
          new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong, Try again later."
          )
        );
    }
  }
};

export const viewAllReviewForTheVenue = async (
  req: Request<{}, {}, {}, { venueId: string }>,
  res: Response
) => {
  try {
    const { venueId } = req.query;
    console.log(venueId);

    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue Id missing.");
    }

    // search for venue from the database
    const venue = await Venue.findOne({
      where: { venueId: venueId },
    });

    // if venue is not found send a "ot Found" response
    if (!venue) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Venue not found");
    }

    // get all reviews for that venue
    const reviews = await VenueReview.find({
      where: { venue: { venueId: venueId } },
      relations: ["user"],
    });

    const transformedReviews = reviews.map((review) => ({
      ...review,
      user: {
        id: review.user.userId,
        firstName: review.user.firstName,
        lastName: review.user.lastName,
        profileImage: review.user.profileImage,
        joined: review.user.createdAt,
      },
    }));

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          count: reviews.length,

          reviews: transformedReviews,
        },
        "Successfully fetched all reviews"
      )
    );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_GATEWAY)
        .json(
          new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong, Try again later."
          )
        );
    }
  }
};

// delete a review
export const removeReview = async (
  req: Request<{}, {}, { venueId: string; reviewId: string }>,
  res: Response
) => {
  const { venueId, reviewId } = req.body;

  try {
    // check is the venueId is not empty and is a valid UUID
    if (!venueId || !isUuid(venueId)) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "VenueId is missing or is an invalid UUID"
      );
    }

    if (!reviewId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Review Id Missing");
    }

    // saerch for the review in  the database
    const review = await VenueReview.findOne({ where: { reviewId: reviewId } });

    // unable to find the review in the database
    if (!review)
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Review Not found");

    const removedReview = await review.remove();

    if (!review)
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Unable to remove review.");

    res
      .status(StatusCode.OK)
      .json(new ApiResponse(StatusCode.OK, {}, "Successfully removed"));
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_GATEWAY)
        .json(
          new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong, Try again later."
          )
        );
    }
  }
};

// update a review
export const updateReview = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
      reviewId: string;
      newComment: string;
      newRating: number;
    }
  >,
  res: Response
) => {
  const { venueId, reviewId, newComment, newRating } = req.body;

  try {
    // check is the venueId is not empty and is a valid UUID
    if (!venueId || !isUuid(venueId)) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "VenueId is missing or is an invalid UUID"
      );
    }

    if (!newRating || !newComment) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "New Comment or rating is missing."
      );
    }

    if (!reviewId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Review Id Missing");
    }

    // saerch for the review in  the database
    const review = await VenueReview.findOne({ where: { reviewId: reviewId } });

    // unable to find the review in the database
    if (!review)
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Review Not found");

    // only chage the detail which is different to the ones on the database.
    if (review.stars != newRating) review.stars = newRating;
    if (review.reviewText != newComment) review.reviewText = newComment;

    const savedReview = review.save();

    if (!savedReview)
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Unable to save review");
    res
      .status(StatusCode.OK)
      .json(new ApiResponse(StatusCode.OK, {}, "Successfully Updated"));
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_GATEWAY)
        .json(
          new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong, Try again later."
          )
        );
    }
  }
};

// view all reviews for currently loggedIn User
export const allReviewByUser = async (req: Request, res: Response) => {
  const token = extractToken(req);
  const decodedToken = verifyAccessToken(token);
  const userId = decodedToken?.userId;
  try {
    if (!userId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "userId missing.");
    }

    // search for venue from the database
    const user = await User.findOne({
      where: { userId },
    });

    // if venue is not found send a "ot Found" response
    if (!user) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "User not found");
    }

    // get all reviews for that venue
    const reviews = await VenueReview.find({
      where: { user: { userId } },
      relations: ["venue", "venue.accessibilityStatus", "venue.coordinates"],
    });

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          count: reviews.length,
          reviews,
        },
        "Successfully fetched all reviews"
      )
    );
  } catch (error) {
    if (error instanceof ApiError) {
      res.status(error.statusCode).json(error);
    } else {
      res
        .status(StatusCode.BAD_GATEWAY)
        .json(
          new ApiError(
            StatusCode.BAD_GATEWAY,
            {},
            "Something went wrong, Try again later."
          )
        );
    }
  }
};

// These could be added in the future.
// like a review
export const likeAReview = async (req: Request, res: Response) => {};

// dislike a review if it is already liked
export const dislikeAReview = async (req: Request, res: Response) => {};

// report an offencive review
export const reportAReview = async (req: Request, res: Response) => {};
