import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Relation,
  OneToOne,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("venue_toilet")
export class VenueToilet extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  toiletId!: string;

  @OneToOne(() => Venue, (venue) => venue.toilet)
  @JoinColumn({
    name: "venue_id",
  })
  venue!: Relation<Venue>;

  @Column({ name: "entry_width", nullable: true })
  entryWidth?: number;

  @Column({ name: "stall_door_width", nullable: true })
  stallDoorWidth?: number;

  @Column({ name: "stall_toilet_clearance_cm", nullable: true })
  stallToiletClearanceCm?: number;

  @Column("simple-array", { name: "height", nullable: true })
  height?: string[];

  @Column("simple-array", { name: "basin_height", nullable: true })
  basinHeight?: string[];

  @Column({ name: "lighting", nullable: true })
  lighting?: string;

  @Column({ name: "toilet_image_1", nullable: true })
  toiletImage1?: string;

  @Column({ name: "toilet_image_1_describe", nullable: true })
  describeToiletImage1?: string;

  @Column({ name: "where_close_toilet_is", nullable: true })
  whereClosestToiletIs?: string;

  @Column("simple-array", { name: "location_of_toilet", nullable: true })
  locationOfToilet?: string[];

  @Column("simple-array", { name: "toilet_classification", nullable: true })
  toiletClassifications?: string[];

  @Column("simple-array", { name: "toilet_usage", nullable: true })
  toiletUsage?: string[];

  @Column("simple-array", { name: "distance_to_toilet", nullable: true })
  distanceToToilet?: string[];

  @Column({ name: "is_journey_to_toilet_flat", nullable: true })
  isJourneyToToiletFlat?: string;

  @Column("simple-array", { name: "ramp_feature", nullable: true })
  rampFeatures?: string[];

  @Column("simple-array", { name: "stairs_features", nullable: true })
  stairsFeatures?: string[];

  @Column("simple-array", { name: "escalator_type", nullable: true })
  escalatorType?: string[];

  @Column("simple-array", { name: "entry_to_toilet", nullable: true })
  entryToToilet?: string[];

  @Column({ name: "doorway_width", nullable: true })
  doorwayWidth?: number;

  @Column({ name: "stall_doorway_width_cm", nullable: true })
  stallDoorwayWidth?: number;

  @Column({ name: "stall_door_toilet_clearance_cm", nullable: true })
  stallDoorToiletClearanceCm?: number;

  @Column("simple-array", { name: "tactile_indicator", nullable: true })
  tactileIndicator?: string[];

  @Column("simple-array", { name: "toilet_rail_location", nullable: true })
  railLocation?: string[];

  @Column("simple-array", { name: "toilet_lightning", nullable: true })
  toiletLightning?: string[];

  @Column("simple-array", { name: "floor_space_in_toilet", nullable: true })
  floorSpaceInToilet?: string[];

  @Column("simple-array", { name: "accessibility_feature", nullable: true })
  accessibilityFeature?: string[];

  @Column({ name: "toilet_image_2", nullable: true })
  toiletImage2?: string;

  @Column({ name: "toilet_image_2_describe", nullable: true })
  describeToiletImage2?: string;

  @Column({ name: "toilet_service_area_video", nullable: true })
  toiletServiceAreaVideo?: string;

  @Column({ name: "stairs_image", nullable: true })
  stairsImage?: string;

  @Column({ name: "stairs_image_describe", nullable: true })
  stairsImageDescribe?: string;

  @Column("simple-array", { name: "lift_features", nullable: true })
  liftFeatures?: string[];

  @Column({ name: "ramp_image", nullable: true })
  rampImage?: string;

  @Column({ name: "ramp_image_describe", nullable: true })
  rampImageDescribe?: string;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
