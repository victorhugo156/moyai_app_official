import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Relation,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("option_for_access")
export class OptionForAccess extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  accessId!: string;

  @ManyToOne(() => Venue, (venue) => venue.optionsForAccess)
  @JoinColumn({ name: "venue_id" })
  venue!: Relation<Venue>;

  @Column({ name: "ramp_width", nullable: true })
  rampWidth?: string;

  @Column({ name: "ramp_length", nullable: true })
  rampLength?: string;

  @Column({ name: "image_of_ramp", nullable: true })
  imageOfRamp?: string;

  @Column("simple-array", { name: "rails_on_ramp", nullable: true })
  railsOnRamp?: string[];

  @Column("simple-array", { name: "rails_on_steps", nullable: true })
  railsOnSteps?: string[];

  @Column("simple-array", { name: "ramp_features", nullable: true })
  rampFeatures?: string[];

  @Column({ name: "number_of_steps", nullable: true })
  numberOfSteps?: string;

  @Column("simple-array", { name: "ramp_for_access", nullable: true })
  rampForAccess?: string[];

  @Column({ name: "entrance_door_cm", nullable: true })
  entranceDoorCm?: string;

  @Column({ name: "other_obstacles", nullable: true })
  otherObstacles?: string;

  @Column("simple-array", { name: "features_of_steps", nullable: true })
  featuresOfSteps?: string[];

  @Column("simple-array", { name: "option_for_access", nullable: true })
  optionForAccess?: string[];

  @Column("simple-array", { name: "entrance_features", nullable: true })
  entranceFeatures?: string[];

  @Column("simple-array", { name: "lift_for_this_access", nullable: true })
  liftForThisAccess?: string[];

  @Column("simple-array", { name: "sinage_and_direction", nullable: true })
  sinageAndDirection?: string[];

  @Column("simple-array", { name: "steps_for_this_access", nullable: true })
  stepsForThisAccess?: string[];

  @Column({ name: "ramp_degree_measurement", nullable: true })
  rampDegreeMeasurement?: string;

  @Column("simple-array", { name: "escalator_for_this_access", nullable: true })
  escalatorForThisAccess?: string[];

  @Column("simple-array", { name: "obstacles_with_the_access", nullable: true })
  obstaclesWithTheAccess?: string[];

  @Column({ name: "image_of_stairs_for_this_access", nullable: true })
  imageOfStairsForThisAccess?: string;

  @Column("simple-array", {
    name: "is_there_obstacles_with_this_access",
    nullable: true,
  })
  isThereObstaclesWithThisAccess?: string[];

  @CreateDateColumn({ name: "created_at", type: "timestamptz" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "timestamptz" })
  updatedAt!: Date;
}
