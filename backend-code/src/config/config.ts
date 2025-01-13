import { DataSource } from "typeorm";
import { User } from "../db/entities/User.js";
import { UserProfileQuestion } from "../db/entities/UserProfileQuestion.js";
import { Venue } from "../db/entities/Venue.js";
import { VenueToilet } from "../db/entities/VenueToilet.js";
import { VenueReview } from "../db/entities/VenueReview.js";
import { VenueDashboardAnalytics } from "../db/entities/VenueDashboardAnalytics.js";
import { VenueEnvironment } from "../db/entities/VenueEnvironment.js";
import { VenueAccessibility } from "../db/entities/VenueAccessibility.js";
import { AccessorInformation } from "../db/entities/AccessorInformation.js";
import { VenueAdditionalInfo } from "../db/entities/VenueAdditionalInformation.js";
import { RefreshToken } from "../db/entities/RefreshToken.js";
import { Favorite } from "../db/entities/Favourites.js";
import { AdminRefreshToken } from "../db/entities/AdminRefreshToken.js";
import { Admin } from "../db/entities/Admin.js";
import fs from "fs";
import path from "path";
import { Coordinates } from "../db/entities/Coordinates.js";
import { OptionForAccess } from "../db/entities/OptionForAccess.js";
import { AccessibilityStatus } from "../db/entities/AccessibilityStatus.js";
const __dirname = new URL(".", import.meta.url).pathname;
const certificatePath = path.join(
  __dirname,
  "../../src/certificate/ca-certificate.crt"
);

export const AppDataSource = new DataSource({
  type: "postgres",
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  synchronize: true,

  ssl: {
    rejectUnauthorized: false,
    ca: fs.readFileSync(certificatePath),
  },
  entities: [
    User,
    VenueAdditionalInfo,
    UserProfileQuestion,
    Venue,
    VenueToilet,
    VenueReview,
    VenueDashboardAnalytics,
    VenueEnvironment,
    VenueAccessibility,
    AccessorInformation,
    RefreshToken,
    Favorite,
    AdminRefreshToken,
    Admin,
    Coordinates,
    OptionForAccess,
    AccessibilityStatus,
  ], // all entities
});
