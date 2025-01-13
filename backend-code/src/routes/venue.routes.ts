import express, { Express, response } from "express";
import {
  getAllVenues,
  getMoreInfoOnVenue,
  getSearchedVenues,
  registerNewVenue,
} from "../controllers/venue/venueController.js";
import { DataSource } from "typeorm";
import { registerAccessor } from "../controllers/user/accessorController.js";
import { upload } from "../controllers/venue/fileController.js";
import {
  uploadLightningImage,
  uploadMenueImage,
  uploadToiletImage,
  uploadVenueDiningAreaImage,
  uploadVenueFrontImage,
} from "../controllers/venue/venueImageController.js";
import { verifyLoginStatus } from "../controllers/auth/loginValidatorController.js";
import {
  addVenueCoordinates,
  getNearbyVenues,
} from "../controllers/venue/coordinatesController.js";
import {
  allReviewByUser,
  leaveAReview,
  removeReview,
  updateReview,
  viewAllReviewForTheVenue,
} from "../controllers/venue/reviewController.js";

const venueRouter = express.Router();

export const initializeVenueRouter = (dataSource: DataSource) => {
  // post routes
  // register a new venue
  venueRouter.post("/register", verifyLoginStatus, (req, res) =>
    registerNewVenue(req, res, dataSource)
  );
  // upload Front image of the venue
  venueRouter.post(
    "/upload/image/front",
    verifyLoginStatus,
    upload.single("image"),
    uploadVenueFrontImage
  );
  // upload image of the dining area
  venueRouter.post(
    "/upload/image/diningArea",
    verifyLoginStatus,
    upload.single("image"),
    uploadVenueDiningAreaImage
  );
  // upload image the menu
  venueRouter.post(
    "/upload/image/menu",
    verifyLoginStatus,
    upload.single("image"),
    uploadMenueImage
  );

  // upload image of the lightning
  venueRouter.post(
    "/upload/image/lightning",
    verifyLoginStatus,
    upload.single("image"),
    uploadLightningImage
  );

  // upload image of the toilet
  venueRouter.post(
    "/upload/image/toilet",
    verifyLoginStatus,
    upload.single("image"),
    uploadToiletImage
  );

  // add, update, remove and get reviews
  venueRouter.post("/postReview", verifyLoginStatus, leaveAReview);
  venueRouter.put("/updateReview", verifyLoginStatus, updateReview);
  venueRouter.delete("/removeReview", verifyLoginStatus, removeReview);
  venueRouter.get("/getReviews", verifyLoginStatus, viewAllReviewForTheVenue);

  venueRouter.post("/addCoordinate", verifyLoginStatus, addVenueCoordinates);
  venueRouter.get("/getNearbyVenues", verifyLoginStatus, getNearbyVenues);

  // get routes
  venueRouter.post("/accesser/register", verifyLoginStatus, registerAccessor);
  venueRouter.get("/getSearchedVenues", verifyLoginStatus, getSearchedVenues);
  venueRouter.get("/getAllVenues", verifyLoginStatus, getAllVenues);
  venueRouter.get("/info/:id", verifyLoginStatus, getMoreInfoOnVenue);

  return venueRouter;
};

export default venueRouter;
