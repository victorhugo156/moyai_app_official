import {
  BaseEntity,
  Column,
  Entity,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Relation,
  PrimaryGeneratedColumn,
} from "typeorm";
import { User } from "./User.js";
import { Admin } from "./Admin.js";

@Entity("admin_refresh_token")
export class AdminRefreshToken extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  id!: string;

  @ManyToOne(() => Admin, (admin) => admin.refreshTokens)
  @JoinColumn({ name: "admin_id" })
  admin!: Relation<Admin>;

  @Column({ name: "jti" })
  jti!: string;

  @Column({ name: "expires_at", type: "time with time zone", nullable: true })
  expiresAt!: Date;

  @CreateDateColumn({
    name: "created_at",
    type: "time with time zone",
  })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
