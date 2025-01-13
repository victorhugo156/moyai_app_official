import {
  BaseEntity,
  Column,
  Entity,
  JoinColumn,
  OneToOne,
  CreateDateColumn,
  UpdateDateColumn,
  PrimaryGeneratedColumn,
  Relation,
} from "typeorm";
import { User } from "./User.js";

@Entity("accessor_information")
export class AccessorInformation extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  accessorId!: string;

  @OneToOne(() => User, (user) => user.accessor)
  @JoinColumn({ name: "user_id" })
  user!: Relation<User>;

  @Column({ name: "right_to_work_form", type: "varchar" })
  rightToWorkForm!: string;

  @Column({ name: "training_completed", type: "bool" })
  trainingCompleted!: boolean;

  @Column({ name: "training_success_marked", type: "bool" })
  trainingSuccessMarked!: boolean;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
