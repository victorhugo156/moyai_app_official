import { Response, Request } from "express";
import { Venue } from "../../db/entities/Venue.js";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { AppDataSource } from "../../config/config.js";
import { Coordinates } from "../../db/entities/Coordinates.js";
import { getProfileQuesitons } from "./venueController.js";

export const getNearbyVenues = async (req: Request, res: Response) => {
  try {
    const questions = await getProfileQuesitons(req);
    const { latitude, longitude, radius = 20 } = req.query;

    if (!latitude || !longitude) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Latitude and longitude are required"
      );
    }

    const lat = parseFloat(latitude.toLocaleString());
    const lon = parseFloat(longitude.toLocaleString());
    const rad = parseFloat(radius.toString());
    const venues = await findNearbyVenues(lat, lon, rad);

    if (!venues) {
      throw new ApiError(StatusCode.NOT_FOUND, {}, "No venue Nearby");
    }

    res.status(200).json(
      new ApiResponse(StatusCode.OK, {
        venueCount: venues.length,
        venues,
        radius,
        userSetting: questions,
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

// get nearby venue from the user current location based on the distance requested by user
async function findNearbyVenues(
  latitude: number,
  longitude: number,
  radiusInKm: number
): Promise<Venue[]> {
  const venueRepository = AppDataSource.getRepository(Venue);

  const result = await venueRepository
    .createQueryBuilder("venue")
    .innerJoinAndSelect("venue.coordinates", "coord")
    .leftJoinAndSelect("venue.accessibilityStatus", "accessibilityStatus")
    .addSelect(
      `(6371 * acos(
        cos(radians(:latitude)) * 
        cos(radians(coord.latitude)) * 
        cos(radians(coord.longitude) - radians(:longitude)) + 
        sin(radians(:latitude)) * 
        sin(radians(coord.latitude))
      ))`,
      "distance"
    )
    .where(
      `(6371 * acos(
        cos(radians(:latitude)) * 
        cos(radians(coord.latitude)) * 
        cos(radians(coord.longitude) - radians(:longitude)) + 
        sin(radians(:latitude)) * 
        sin(radians(coord.latitude))
      )) <= :radiusInKm`
    )
    .setParameters({
      latitude,
      longitude,
      radiusInKm,
    })
    .orderBy("distance", "ASC") // Optional: Sort by distance
    .getRawAndEntities();

  // Combine entities with distance

  return result.entities;
}

// add venue coordinates to the database
export const addVenueCoordinates = async (
  req: Request<
    {},
    {},
    {
      longitude: number;
      latitude: number;
      venueId: string;
    }
  >,
  res: Response
) => {
  const { longitude, latitude, venueId } = req.body;

  try {
    if (!latitude || !longitude) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Latitude and longitude is required"
      );
    }
    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue Id is required");
    }

    // see if the venueId is valid
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) throw new ApiError(StatusCode.NOT_FOUND, {}, "Venue not found");

    //if the venue is valid create a new Coordinate table instance
    const newCoordinate = Coordinates.create({
      venueId,
      longitude,
      latitude,
    });

    const savedCoordinate = await newCoordinate.save();
    if (!savedCoordinate)
      throw new ApiError(
        StatusCode.NOT_FOUND,
        {},
        "Unable to save venue coordinate"
      );

    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          { savedCoordinate },
          "Successfully saved"
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
