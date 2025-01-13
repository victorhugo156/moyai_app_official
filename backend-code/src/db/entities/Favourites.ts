import {
  Entity,
  PrimaryColumn,
  ManyToOne,
  JoinColumn,
  BaseEntity,
  Relation,
  CreateDateColumn,
} from "typeorm";
import { User } from "./User.js";
import { Venue } from "./Venue.js";

@Entity("favorites")
export class Favorite extends BaseEntity {
  @PrimaryColumn("uuid")
  userId!: string;

  @PrimaryColumn("uuid")
  venueId!: string;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @ManyToOne(() => User, (user) => user.favorites, { onDelete: "CASCADE" })
  @JoinColumn({ name: "userId" })
  user!: Relation<User>;

  @ManyToOne(() => Venue, (venue) => venue.favorites, { onDelete: "CASCADE" })
  @JoinColumn({ name: "venueId" })
  venue!: Relation<Venue>;
}
