import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  OneToOne,
  JoinColumn,
  CreateDateColumn,
  Relation,
  UpdateDateColumn,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("venue_accessibility")
export class VenueAccessibility extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  accessibilityId!: string;

  // Inside Features (simple array of strings)
  @Column("simple-array", { name: "inside_features", nullable: true })
  insideFeatures?: string[];

  // Flooring (simple array of strings)
  @Column("simple-array", { name: "flooring", nullable: true })
  flooring?: string[];

  // Room to Move
  @Column("simple-array", { name: "room_to_move", nullable: true })
  roomToMove?: string[];

  // Dining Area Images and Descriptions
  @Column({ name: "dining_area_image_1", nullable: true })
  diningAreaImage1?: string;

  @Column({ name: "describe_dining_area_image_1", nullable: true })
  describeDiningAreaImage1?: string;

  @Column({ name: "dining_area_image_2", nullable: true })
  diningAreaImage2?: string;

  @Column({ name: "describe_dining_area_image_2", nullable: true })
  describeDiningAreaImage2?: string;

  // Chair Measurements (JSON structure)
  @Column({ type: "json", name: "chair_measurements", nullable: true })
  chairMeasurements?: { height: number; width: number; type: string }[];

  // Table Measurements (JSON structure)
  @Column({ type: "json", name: "table_measurements", nullable: true })
  tableMeasurements?: { height: number; width: number; type: string }[];

  // Escalator Features
  @Column("simple-array", { name: "escalator_type", nullable: true })
  escalatorType?: string[];

  @Column({ name: "escalator_image", nullable: true })
  escalatorImage?: string;

  @Column({ name: "describe_escalator_image", nullable: true })
  describeEscalatorImage?: string;

  // Lift Features
  @Column("simple-array", { name: "lift_feature", nullable: true })
  liftFeature?: string[];

  @Column({ name: "lift_image", nullable: true })
  liftImage?: string;

  @Column({ name: "describe_lift_image", nullable: true })
  describeLiftImage?: string;

  // Stairs Features
  @Column("simple-array", { name: "stairs_features", nullable: true })
  stairsFeatures?: string[];

  @Column({ name: "stair_image", nullable: true })
  stairImage?: string;

  @Column({ name: "describe_stairs_image", nullable: true })
  describeStairsImage?: string;

  // Ramp Features
  @Column("simple-array", { name: "ramp_feature", nullable: true })
  rampFeature?: string[];

  @Column({ name: "ramp_image", nullable: true })
  rampImage?: string;

  @Column({ name: "describe_ramp_image", nullable: true })
  describeRampImage?: string;

  // Venue Relationship
  @OneToOne(() => Venue, (venue) => venue.accessibility)
  @JoinColumn({ name: "venue_id" })
  venue!: Relation<Venue>;

  // Timestamps
  @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "timestamp with time zone" })
  updatedAt!: Date;
}
