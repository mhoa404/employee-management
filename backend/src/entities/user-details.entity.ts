// backend/src/entities/user-details.entity.ts
import { Entity, Column, OneToOne, PrimaryColumn, JoinColumn } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class UserDetails {
  @PrimaryColumn()
  userId: number;

  @Column({ default: 'USER' })
  role: string;

  @Column()
  full_name: string;

  @Column()
  phone: string;

  @Column()
  department: string;
  
  @Column({ nullable: true, default: '' })
  avatar: string;

  @OneToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;
}
