import { Response, Request } from "express";
import { Venue } from "../../db/entities/Venue.js";
import { VenueDashboardAnalytics } from "../../db/entities/VenueDashboardAnalytics.js";
import { VenueAccessibility } from "../../db/entities/VenueAccessibility.js";
import { VenueAdditionalInfo } from "../../db/entities/VenueAdditionalInformation.js";
import { VenueEnvironment } from "../../db/entities/VenueEnvironment.js";
import { VenueToilet } from "../../db/entities/VenueToilet.js";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { DataSource } from "typeorm/browser";
import { ILike } from "typeorm";
import { Favorite } from "../../db/entities/Favourites.js";
import { OptionForAccess } from "../../db/entities/OptionForAccess.js";
import { Coordinates } from "../../db/entities/Coordinates.js";
import { getCoordinates } from "../../utils/LocationHelper.js";
import { VenueReview } from "../../db/entities/VenueReview.js";
import { extractToken } from "../../utils/HelperFunctions.js";
import { verifyAccessToken } from "../../utils/JsonWebTokenGenerator.js";
import { User } from "../../db/entities/User.js";
import { AccessibilityStatus } from "../../db/entities/AccessibilityStatus.js";
import { mapVenueAccessibilityPercentage } from "./venueHelper.js";
import { UserProfileQuestion } from "../../db/entities/UserProfileQuestion.js";
import { all } from "axios";
import { List } from "aws-sdk/lib/model/index.js";

interface ReqVenueData {
  venue: Partial<Venue>;
  accessibility: Partial<VenueAccessibility>;
  additionalInformation: Partial<VenueAdditionalInfo>;
  dashboardAnalytics: Partial<VenueDashboardAnalytics>;
  environment: Partial<VenueEnvironment>;
  toilets: Partial<VenueToilet>;
  option: Partial<OptionForAccess>[];
}

export const registerNewVenue = async (
  req: Request<{}, {}, ReqVenueData>,
  res: Response,
  dataSource: DataSource
): Promise<void> => {
  try {
    const {
      venue,
      accessibility,
      additionalInformation,
      environment,
      toilets,
      option,
    } = req.body;

    console.log(toilets);

    // if the requested data is not given then it will throw Error 400.
    if (
      !venue ||
      !accessibility ||
      !additionalInformation ||
      !environment ||
      !toilets ||
      !option
    ) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {
          venue,
          accessibility,
          additionalInformation,
          environment,
          toilets,
          option,
        },
        "Please fill all fields first"
      );
    }

    const savedVenueId = await dataSource.transaction(
      async (transactionalEntityManager) => {
        const savedVenue = await transactionalEntityManager.save(Venue, venue);

        if (!savedVenue) {
          throw new ApiError(
            StatusCode.BAD_REQUEST,
            {
              venue,
              accessibility,
              additionalInformation,
              environment,
              toilets,
              option,
            },
            "Cannot saved the value in the venue table."
          );
        }

        await transactionalEntityManager.save(VenueAccessibility, {
          ...accessibility,
          venue: savedVenue,
        });

        await transactionalEntityManager.save(VenueAdditionalInfo, {
          ...additionalInformation,
          venue: savedVenue,
        });
        console.log("add");

        await transactionalEntityManager.save(VenueEnvironment, {
          ...environment,
          venue: savedVenue,
        });

        await transactionalEntityManager.save(VenueToilet, {
          ...toilets,
          venue: savedVenue,
        });

        // Save multiple option for access info
        const optionEntity = option.map((option) => ({
          ...option,
          venue: savedVenue,
        }));
        await transactionalEntityManager.save(OptionForAccess, optionEntity);

        const coordinates = await getCoordinates(
          venue.address?.toLocaleString() || ""
        );
        if (!coordinates) {
          throw new ApiError(
            StatusCode.BAD_REQUEST,
            {},
            "See if the address is not empty or is a valid address"
          );
        }

        const newCoordinates = Coordinates.create({
          latitude: coordinates.lat,
          longitude: coordinates.lng,
          venue: savedVenue,
        });

        await transactionalEntityManager.save(Coordinates, newCoordinates);

        return savedVenue.venueId;
      }
    );

    const findVenue = await Venue.findOne({
      where: { venueId: savedVenueId },
      relations: [
        "coordinates",
        "toilet",
        "review",
        "dashboardAnalytics",
        "accessibility",
        "venueEnvironments",
        "optionsForAccess",
        "additionalInformation",
      ],
    });
    const mapAccessibility = mapVenueAccessibilityPercentage(findVenue!);

    if (!findVenue)
      throw new ApiError(StatusCode.NOT_FOUND, {}, "Venue Not found");

    const accessibilityStatus = AccessibilityStatus.create({
      venueId: findVenue.venueId,
      mobilityAidUsage: mapAccessibility.mobilityAidOrWalkingChallanging,
      overwhelmedByNoiseOrLight: mapAccessibility.getOverwhelemdWithNoiseLights,
      hasInvisibleDisability: mapAccessibility.haveInvisibleDisability,
      foodIntolerances: mapAccessibility.haveFoodIntolerance,
    });

    try {
      const saved = await accessibilityStatus.save();
    } catch (error) {
      console.error("Error saving accessibility status:", error);
      throw new ApiError(
        StatusCode.BAD_GATEWAY,
        {},
        "Unable to determine map accessibility info"
      );
    }

    // if the venue is created send a success response
    res.status(StatusCode.CREATED).json(
      new ApiResponse(StatusCode.CREATED, {
        id: venue.venueId,
        venueDetails: {
          venue,
          accessibility,
          additionalInformation,
          environment,
          toilets,
        },
      })
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

// returns list of venues when user search their name
export const getSearchedVenues = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { keyword } = req.query;

  try {
    const searchedVenue = await Venue.find({
      where: { businessName: ILike(`${keyword}%`) },
      relations: ["coordinates"],
    });
    if (searchedVenue.length == 0) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Cannot find the venue, Please Check if the Name of the venue is correct"
      );
    }

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          searchedVenue,
          "Searched Venue was found"
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

// returns all venues
export const getAllVenues = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const questions = await getProfileQuesitons(req);

    const allVenues = await Venue.find({
      relations: ["coordinates", "accessibilityStatus"],
    });

    if (allVenues.length === 0) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Cannot get any venues");
    }

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          venueCount: allVenues.length,
          venues: allVenues,
          userSetting: questions,
        },
        "All venues fetched"
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

// get more details about a venue
export const getMoreInfoOnVenue = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { id } = req.params; // Extract the ID from the request parameters

  try {
    const venue = await Venue.findOne({
      where: { venueId: id },
      relations: [
        "coordinates",
        "toilet",
        "review",
        "dashboardAnalytics",
        "accessibility",
        "venueEnvironments",
        "optionsForAccess",
        "additionalInformation",
      ],
    });

    const token = extractToken(req);
    const decodedToken = verifyAccessToken(token);

    const userReview = await VenueReview.findOne({
      where: { user: { userId: decodedToken?.userId }, venue: { venueId: id } },
    });

    if (!venue) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Can't get more info on the venue"
      );
    }

    res.status(StatusCode.OK).json(
      new ApiResponse(
        StatusCode.OK,
        {
          venue,
          userReview: userReview,
        },
        "Venue Detail successfully fetched"
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
export const getProfileQuesitons = async (
  req: Request
): Promise<UserProfileQuestion> => {
  const token = extractToken(req);
  const decodeToken = verifyAccessToken(token);

  if (!decodeToken)
    throw new ApiError(StatusCode.UNAUTHORIZED, {}, "Invalid or Expired token");

  // search for the user.
  const user = await User.findOne({
    where: { userId: decodeToken.userId },
    relations: ["userProfileQuestion"],
  });

  // check if the user is found.
  if (!user) throw new ApiError(StatusCode.NOT_FOUND, {}, "Cannot find user");
  const questions = user.userProfileQuestion;

  // throw error if question is null
  if (!questions)
    throw new ApiError(
      StatusCode.BAD_REQUEST,
      {},
      "User requirements not found."
    );

  return questions;
};
