import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  UpdateDateColumn,
  Relation,
} from "typeorm";
import { Venue } from "./Venue.js";
import { User } from "./User.js";

@Entity("venue_review")
export class VenueReview extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  reviewId!: string;

  @Column({ name: "stars", type: "int" })
  stars!: number; // Out of 5

  // relation with venue table
  @ManyToOne(() => Venue, (venue) => venue.review)
  @JoinColumn({
    name: "venue_id",
  })
  venue!: Relation<Venue>;

  // relation with user table
  @ManyToOne(() => User, (user) => user.review)
  @JoinColumn({
    name: "user_id",
  })
  user!: Relation<User>;

  @Column({ name: "review_text", nullable: true })
  reviewText?: string;

  @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "timestamp with time zone" })
  updatedAt!: Date;
}
