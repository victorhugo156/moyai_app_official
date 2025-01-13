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

@Entity("venue_environment")
export class VenueEnvironment extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  environmentId!: string;

  // Relationship with Venue
  @OneToOne(() => Venue, (venue) => venue.venueEnvironments)
  @JoinColumn({ name: "venue_id" })
  venue!: Relation<Venue>;

  // Lightning Information
  @Column("simple-array", { name: "venue_lightning", nullable: true })
  venueLightning?: string[];

  @Column({ name: "image_of_lightning", nullable: true })
  imageOfLightning?: string;

  @Column({ name: "image_of_lightning_description", nullable: true })
  imageOfLightningDescribe?: string;

  @Column({ name: "image_of_lightning_2", nullable: true })
  imageOfLightning2?: string;

  // Visual Accessibility
  @Column("simple-array", { name: "visual_accessibility", nullable: true })
  visualAccessibility?: string[];

  // Sound Information
  @Column({
    name: "avg_decibel_reading",
    nullable: true,
  })
  avgDecibelReading?: string;

  @Column({
    name: "max_decibel_reading",
    nullable: true,
  })
  maxDecibelReading?: string;

  @Column({ name: "time_of_reading", nullable: true })
  timeOfReading?: string;

  @Column("simple-array", { name: "sound_characteristics", nullable: true })
  soundCharacteristics?: string[];

  @Column({ name: "other_sounds", nullable: true })
  otherSounds?: string;

  @Column({ name: "recording_dining_area_sound", nullable: true })
  recordingDiningAreaSound?: string;

  @Column("simple-array", { name: "hearing_accessibility", nullable: true })
  hearingAccessibility?: string[];

  // Flooring Information
  @Column("simple-array", { name: "flooring", nullable: true })
  flooring?: string[];

  @Column({ name: "image_of_serving_area", nullable: true })
  imageOfServingArea?: string;

  @Column({ name: "image_of_serving_area_description", nullable: true })
  imageOfServingAreaDescribe?: string;

  @Column({ name: "image_of_serving_area_2", nullable: true })
  imageOfServingArea2?: string;

  @Column({ name: "image_of_serving_area_2_description", nullable: true })
  imageOfServingArea2Describe?: string;

  // Smell and Other Sensory Information
  @Column("simple-array", { name: "smell", nullable: true })
  smell?: string[];

  @Column({ name: "other_smells", nullable: true })
  otherSmells?: string;

  @Column("simple-array", { name: "temperature", nullable: true })
  temperature?: string[];

  @Column("simple-array", { name: "visual_stimulation", nullable: true })
  visualStimulation?: string[];

  @Column({ name: "image_of_visual_overwhelm", nullable: true })
  imageOfVisualOverwhelm?: string;

  @Column({ name: "image_of_visual_overwhelm_description", nullable: true })
  imageOfVisualOverwhelmDescribe?: string;

  @Column({ name: "image_of_visual_overwhelm_2", nullable: true })
  imageOfVisualOverwhelm2?: string;

  // Overwhelm Management
  @Column("simple-array", { name: "overwhelm_management", nullable: true })
  overwhelmManagement?: string[];

  // Other Environmental Details
  @Column({ name: "animals_welcome", nullable: true })
  animalsWelcome?: string;

  // Timestamps
  @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "timestamp with time zone" })
  updatedAt!: Date;
}
