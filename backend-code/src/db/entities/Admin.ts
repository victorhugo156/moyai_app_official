import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  OneToMany,
} from "typeorm";
import { AdminRefreshToken } from "./AdminRefreshToken.js";

@Entity("admin")
export class Admin extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  userId!: string;

  @OneToMany(() => AdminRefreshToken, (token) => token.admin)
  refreshTokens!: AdminRefreshToken[];

  @Column({ name: "full_name", length: 50 })
  fullName!: string;

  @Index()
  @Column({ name: "email", unique: true, length: 100 })
  email!: string;

  @Index()
  @Column({ name: "phone_number", unique: true, length: 15 })
  phoneNumber!: string;

  @Column({ name: "password" })
  password!: string;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
