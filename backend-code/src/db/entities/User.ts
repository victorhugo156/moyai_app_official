import {
  Entity,
  BaseEntity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Relation,
  Index,
  OneToOne,
  OneToMany,
} from "typeorm";
import { UserProfileQuestion } from "./UserProfileQuestion.js";
import { VenueReview } from "./VenueReview.js";
import { AccessorInformation } from "./AccessorInformation.js";
import { RefreshToken } from "./RefreshToken.js";
import { Favorite } from "./Favourites.js";

@Entity("user")
export class User extends BaseEntity {
  @PrimaryGeneratedColumn("uuid")
  userId!: string;

  @OneToOne(
    () => UserProfileQuestion,
    (profileQuestions) => profileQuestions.user
  )
  userProfileQuestion?: UserProfileQuestion;

  @OneToMany(() => VenueReview, (venueReview) => venueReview.user)
  review?: VenueReview[];

  @OneToMany(() => RefreshToken, (token) => token.user)
  refreshTokens!: RefreshToken[];

  @OneToOne(() => AccessorInformation, (info) => info.user)
  accessor?: AccessorInformation;

  @OneToMany(() => Favorite, (favorite) => favorite.user)
  favorites?: Favorite[];

  @Column({ name: "first_name", length: 50 })
  firstName!: string;

  @Column({ name: "last_name", length: 50 })
  lastName!: string;

  @Index()
  @Column({ name: "email", unique: true, length: 100 })
  email!: string;

  @Index()
  @Column({ name: "dob", nullable: true, type: "date" })
  dob!: Date;

  @Index()
  @Column({ name: "phone_number", unique: true, length: 15 })
  phoneNumber!: string;

  @Column({ name: "password" })
  password!: string;

  @Column({ name: "profile_image", nullable: true })
  profileImage?: string;

  @CreateDateColumn({ name: "created_at", type: "time with time zone" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at", type: "time with time zone" })
  updatedAt!: Date;
}
