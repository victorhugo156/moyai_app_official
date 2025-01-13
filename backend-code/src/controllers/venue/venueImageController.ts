import { Request, Response } from "express";
import ApiError from "../../utils/ApiError.js";
import ApiResponse, { StatusCode } from "../../utils/ApiResponse.js";
import { Venue } from "../../db/entities/Venue.js";
import { uploadImage } from "./fileController.js";
import { VenueAdditionalInfo } from "../../db/entities/VenueAdditionalInformation.js";
import { VenueAccessibility } from "../../db/entities/VenueAccessibility.js";
import { VenueEnvironment } from "../../db/entities/VenueEnvironment.js";
import { VenueToilet } from "../../db/entities/VenueToilet.js";

// uploads the front image of the venue
export const uploadVenueFrontImage = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
    }
  >,
  res: Response
) => {
  const { venueId } = req.body;

  try {
    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.VENUE_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    venue.frontImage = imageUrl;
    await venue.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(new ApiResponse(StatusCode.OK, { imageUrl }, "Successful"));
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

// upload the diningAreaImage
export const uploadVenueDiningAreaImage = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
    }
  >,
  res: Response
) => {
  const { venueId } = req.body;

  try {
    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const venue = await Venue.findOne({
      where: { venueId },
    });

    if (!venue) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }
    const accessibility = await VenueAccessibility.findOne({
      where: { venue: { venueId } },
    });

    if (!accessibility) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Accessibility not found");
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.VENUE_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    accessibility.diningAreaImage1 = imageUrl;
    await accessibility.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          { diningAreaImage: imageUrl },
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
// upload the menuImage in venue additional information table
export const uploadMenueImage = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
    }
  >,
  res: Response
) => {
  const { venueId } = req.body;

  try {
    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }
    const additionalInformation = await VenueAdditionalInfo.findOne({
      where: { venue },
    });

    if (!additionalInformation) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Additional Information table not found"
      );
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.VENUE_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    additionalInformation.menuImage1 = imageUrl;
    await additionalInformation.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(StatusCode.OK, { menueImage: imageUrl }, "Successful")
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

// upload the lightning image in venue environment table
export const uploadLightningImage = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
    }
  >,
  res: Response
) => {
  const { venueId } = req.body;

  try {
    if (!venueId) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "VenueId not provided");
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }
    const environment = await VenueEnvironment.findOne({
      where: { venue },
    });

    if (!environment) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "Venue environment table not found"
      );
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.VENUE_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    environment.imageOfLightning = imageUrl;
    await environment.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(
        new ApiResponse(
          StatusCode.OK,
          { lightningImage: imageUrl },
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

// upload the toilet image
export const uploadToiletImage = async (
  req: Request<
    {},
    {},
    {
      venueId: string;
      toiletId: string;
    }
  >,
  res: Response
) => {
  const { venueId, toiletId } = req.body;
  try {
    if (!venueId || !toiletId) {
      throw new ApiError(
        StatusCode.BAD_REQUEST,
        {},
        "venueId or toiletId not provided"
      );
    }

    if (!req.file) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "No file uploaded");
    }

    // search for the venue and id the venue was not found throw an error
    const venue = await Venue.findOne({ where: { venueId } });
    if (!venue) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Venue not found");
    }
    const toilet = await VenueToilet.findOne({
      where: { toiletId: toiletId },
    });

    if (!toilet) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Toilet was not found");
    }

    const fileBuffer = req.file.buffer;
    const fileName = `${Date.now()}-${req.file.originalname}`;

    // calling uploadImage functionw which will upload the image to the Amazon s3 bucket
    const imageUrl = await uploadImage(
      process.env.VENUE_BUCKET_NAME || "",
      fileName,
      fileBuffer,
      req.file.mimetype
    );

    if (!imageUrl) {
      throw new ApiError(StatusCode.BAD_REQUEST, {}, "Failed to upload image");
    }

    toilet.toiletImage1 = imageUrl;
    await toilet.save();

    // sends Image url back if successful
    res
      .status(StatusCode.OK)
      .json(
        new ApiError(StatusCode.OK, { toiletImage: imageUrl }, "Successful")
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
