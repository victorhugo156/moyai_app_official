import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  Index,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
} from "typeorm";
import { VenueToilet } from "./VenueToilet.js";
import { VenueReview } from "./VenueReview.js";
import { VenueDashboardAnalytics } from "./VenueDashboardAnalytics.js";
import { VenueAccessibility } from "./VenueAccessibility.js";
import { VenueEnvironment } from "./VenueEnvironment.js";
import { VenueAdditionalInfo } from "./VenueAdditionalInformation.js";
import { Favorite } from "./Favourites.js";
import { Coordinates } from "./Coordinates.js";
import { OptionForAccess } from "./OptionForAccess.js";
import { AccessibilityStatus } from "./AccessibilityStatus.js";

@Entity("venue")
export class Venue extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  venueId!: string;

  @Index()
  @Column({ name: "name", length: 100 })
  name!: string;

  @Column({ name: "phone", nullable: true })
  phone?: string;

  @Column({ name: "signature", nullable: true })
  signature?: string;

  @Index()
  @Column({ name: "email", nullable: true })
  email?: string;

  @Column({ type: "simple-array", name: "opening_hours", nullable: true })
  openingHours?: string[];

  @Column({ name: "front_image_of_business_describe", nullable: true })
  frontImageOfBusinessDescribe?: string;

  @Column({ name: "consent_obtained", default: false })
  consentObtained!: boolean;

  @Column({ name: "front_image", nullable: true })
  frontImage?: string;

  @Column({
    type: "simple-array",
    name: "accessible_parking_available",
    nullable: true,
  })
  accessibleParkingAvailable?: string[];

  @Column({ name: "closest_accessible_parking", nullable: true })
  closestAccessibleParking?: string;

  @Column({ name: "distance_to_closest_accessible_parking", nullable: true })
  distanceToClosestAccessibleParking?: string;

  // @Column({ type: "jsonb", nullable: true })
  // optionsForAccess: any;

  // New columns for venueInformation
  @Column({ name: "assessor_name", nullable: true })
  assessorName?: string;

  @Column({ name: "business_name", nullable: true })
  businessName?: string;

  @Column({ name: "business_type", nullable: true })
  businessType?: string;

  @Column({ type: "simple-array", nullable: true })
  address?: string[];

  @Column({ name: "front_image_of_business", nullable: true })
  frontImageOfBusiness?: string;

  @OneToOne(() => VenueToilet, (toilet) => toilet.venue)
  toilet!: VenueToilet;

  @OneToOne(() => AccessibilityStatus, (access) => access.venue)
  accessibilityStatus!: VenueToilet;

  @OneToMany(() => VenueReview, (review) => review.venue)
  review!: VenueReview[];

  @OneToMany(
    () => VenueDashboardAnalytics,
    (dashboardAnalytics) => dashboardAnalytics.venue
  )
  dashboardAnalytics!: VenueDashboardAnalytics[];

  // todo:: checking for now remove if not working
  @OneToMany(() => OptionForAccess, (option) => option.venue)
  optionsForAccess!: OptionForAccess[];

  @OneToOne(() => Coordinates, (coordinate) => coordinate.venue)
  coordinates!: Coordinates;

  @OneToOne(() => VenueAccessibility, (accessibility) => accessibility.venue)
  accessibility!: VenueAccessibility;

  @OneToOne(() => VenueEnvironment, (env) => env.venue)
  venueEnvironments!: VenueEnvironment;

  @OneToOne(() => VenueAdditionalInfo, (info) => info.venue)
  additionalInformation!: VenueAdditionalInfo;

  @OneToMany(() => Favorite, (favorite) => favorite.venue)
  favorites?: Favorite[];

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
