import { User } from "./User.js";

import {
  Entity,
  BaseEntity,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  JoinColumn,
  Relation,
  OneToOne,
  PrimaryColumn,
} from "typeorm";

@Entity("user_profile_question")
export class UserProfileQuestion extends BaseEntity {
  @PrimaryColumn({ name: "user_id", type: "uuid" })
  userId!: string;

  @OneToOne(() => User, (user) => user.userProfileQuestion)
  @JoinColumn({ name: "user_id" })
  user?: Relation<User>;

  @Column({ name: "uses_mobility_aid", nullable: false, default: false })
  mobilityAidUsage?: boolean;

  @Column({
    name: "overwhelmed_by_noise_or_light",
    nullable: false,
    default: false,
  })
  overwhelmedByNoiseOrLight?: boolean;

  @Column({ name: "has_invisible_disability", nullable: false, default: false })
  hasInvisibleDisability?: boolean;

  @Column({ name: "food_intolerances", nullable: false, default: false })
  foodIntolerances?: boolean;
  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
