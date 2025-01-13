import express, { Router, Request, Response } from "express";
import {
  editCurrentUserDetail,
  getCurrentUserDetails,
  loginUser,
  registerUser,
  validateVerificationCode,
  verificationCode,
} from "../controllers/auth/userController.js";
import {
  refreshToken,
  verifyLoginStatus,
} from "../controllers/auth/loginValidatorController.js";
import {
  addToFavourite,
  checkIfVenueIsInFav,
  getAllFavourites,
  removeFromFavoutite,
} from "../controllers/venue/FavouriteController.js";
import {
  updateAccessibilityPreferance,
  updateAccountDetails,
  uploadProfileImage,
} from "../controllers/user/userController.js";
import { upload } from "../controllers/venue/fileController.js";
import ApiResponse, { StatusCode } from "../utils/ApiResponse.js";
import { allReviewByUser } from "../controllers/venue/reviewController.js";

const userRouter = express.Router();
userRouter.route("/sendVerificationCode").post(verificationCode);
userRouter.route("/validateVerificationCode").post(validateVerificationCode);
userRouter.route("/register").post(registerUser);
userRouter.route("/login").post(loginUser);
userRouter.route("/refreshToken").post(refreshToken);
userRouter
  .route("/getCurrentUserDetail")
  .get(verifyLoginStatus, getCurrentUserDetails);

userRouter.post(
  "/updateUserPreference",
  verifyLoginStatus,
  updateAccessibilityPreferance
);
userRouter.post("/editDetail", verifyLoginStatus, editCurrentUserDetail);
userRouter.post("/addToFavourite", verifyLoginStatus, addToFavourite);
userRouter.post("/removeFavourite", verifyLoginStatus, removeFromFavoutite);
userRouter.post("/updateUserDetails", verifyLoginStatus, updateAccountDetails);
userRouter.get("/getAllFavourite", verifyLoginStatus, getAllFavourites);
userRouter.get("/checkFav", verifyLoginStatus, checkIfVenueIsInFav);
userRouter.post(
  "/uploadProfileImage",
  upload.single("image"),
  uploadProfileImage
);

userRouter.get("/getAllReviewsByUser", verifyLoginStatus, allReviewByUser);

// todo:: if the refresh token expiry is close. generate a new one
userRouter.get(
  "/getLoginStatus",
  verifyLoginStatus,
  (req: Request, res: Response) => {
    res
      .status(StatusCode.OK)
      .json(new ApiResponse(StatusCode.OK, {}, "Logged in successfully", true));
  }
);

export default userRouter;
