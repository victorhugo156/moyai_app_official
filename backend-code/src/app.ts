import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import { AppDataSource } from "./config/config.js";
import "reflect-metadata";

const app = express();

app.use(
  cors({
    origin: process.env.CORS_ORIGIN,
    credentials: true,
  })
);

app.use(
  express.json({
    limit: "10MB",
  })
);

app.use(
  express.urlencoded({
    extended: true,
    limit: "16kb",
  })
);

app.use(cookieParser());
app.use(express.static("public"));
// app.use(verifyLoginStatus);

// routes import
import userRouter from "./routes/user.routes.js";
import venueRouter, { initializeVenueRouter } from "./routes/venue.routes.js";

app.use("/api/v1/users", userRouter);
app.use("/api/v1/venue", initializeVenueRouter(AppDataSource));

export { app };
