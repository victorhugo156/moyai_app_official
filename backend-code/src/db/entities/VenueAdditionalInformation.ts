import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Relation,
  BaseEntity,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("venue_additional_info")
export class VenueAdditionalInfo extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  infoId!: string;

  // Relationship with Venue
  @OneToOne(() => Venue, (venue) => venue.additionalInformation)
  @JoinColumn({ name: "venue_id" })
  venue!: Relation<Venue>;

  // Food Information
  @Column("simple-array", { name: "food_intolerance_option", nullable: true })
  foodIntoleranceOption?: string[];

  @Column({ name: "eptos_portability", nullable: true })
  eptosPortability?: string;

  // Menu Images and Links
  @Column({ name: "menu_image_1", nullable: true })
  menuImage1?: string;

  @Column({ name: "menu_image_2", nullable: true })
  menuImage2?: string;

  @Column({ name: "menu_url", nullable: true })
  menuUrl?: string;

  // Social Media Links
  @Column({ name: "instagram_link", nullable: true })
  instagramLink?: string;

  @Column({ name: "website_link", nullable: true })
  websiteLink?: string;

  @Column({ name: "facebook_link", nullable: true })
  facebookLink?: string;

  @Column({ name: "twitter_x_link", nullable: true })
  twitterXLink?: string;

  @Column({ type: "json", name: "other_social_media", nullable: true })
  otherSocialMedia?: Record<string, string>; // e.g., { UberEats: "link" }

  // Website Information
  @Column("simple-array", { name: "website_features", nullable: true })
  websiteFeatures?: string[];

  @Column("simple-array", { name: "website_accessibility", nullable: true })
  websiteAccessibility?: string[];

  // Additional Features
  @Column({ name: "staff_training", nullable: true })
  staffTraining?: string;

  @Column({ name: "additional_helpful_features", nullable: true })
  additionalHelpfulFeatures?: string;

  @Column({ name: "venue_live_events", nullable: true })
  venueLiveEvents?: string;

  @Column({ name: "broken_or_missing_info", nullable: true })
  brokenOrMissingInfo?: string;

  // Timestamps
  @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "timestamp with time zone" })
  updatedAt!: Date;
}
