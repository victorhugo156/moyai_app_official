import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  PrimaryColumn,
  JoinColumn,
  BaseEntity,
  Relation,
} from "typeorm";
import { Venue } from "./Venue.js";

@Entity("coordinate")
export class Coordinates extends BaseEntity {
  @PrimaryColumn({ name: "venueId", type: "uuid" })
  venueId!: string;

  @Column({ name: "longitude", type: "float" })
  longitude!: number;

  @Column({ name: "latitude", type: "float" })
  latitude!: number;

  @OneToOne(() => Venue, (venue) => venue.coordinates)
  @JoinColumn({ name: "venueId" }) // Ensures venueId is both primary and foreign key
  venue!: Relation<Venue>;
}
