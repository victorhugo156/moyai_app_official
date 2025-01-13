import {
  BaseEntity,
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryColumn,
  Relation,
  UpdateDateColumn,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("accessibility_status")
export class AccessibilityStatus extends BaseEntity {
  @PrimaryColumn({ name: "venue_id", type: "uuid" })
  venueId!: string;

  @OneToOne(() => Venue, (venue) => venue.accessibilityStatus)
  @JoinColumn({ name: "venue_id" })
  venue?: Relation<Venue>;

  @Column({ name: "mobility_aid", nullable: true })
  mobilityAidUsage?: number;

  @Column({ name: "overwhelmed_by_noise_or_light", nullable: true })
  overwhelmedByNoiseOrLight?: number;

  @Column({ name: "invisible_disability", nullable: true })
  hasInvisibleDisability?: number;

  @Column({ name: "food_intolerances", nullable: true })
  foodIntolerances?: number;
  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
