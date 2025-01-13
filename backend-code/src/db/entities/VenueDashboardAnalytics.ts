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

@Entity("venue_dashboard_analytics")
export class VenueDashboardAnalytics extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  analyticsId!: string;

  @OneToOne(() => Venue, (venue) => venue.dashboardAnalytics)
  @JoinColumn({
    name: "venue_id",
  })
  venue!: Relation<Venue>;

  @Column({ name: "check_ins", type: "int" })
  checkIns!: number;

  @Column({ name: "reviews", type: "int" })
  reviews!: number;

  @Column({ name: "feedback", nullable: true })
  feedback?: string;

  @Column({ name: "views", type: "int" })
  views!: number;

  @Column({ name: "saved_to_favorites", type: "int" })
  savedToFavorites!: number;

  @Column({ name: "information_accuracy_thumbs_up", type: "int" })
  informationAccuracyThumbsUp!: number;

  @Column({ name: "information_accuracy_thumbs_down", type: "int" })
  informationAccuracyThumbsDown!: number;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
