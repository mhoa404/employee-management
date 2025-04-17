// backend/src/entities/user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, OneToOne, OneToMany } from 'typeorm';
import { UserDetails } from './user-details.entity';
import { WorkRequest } from './work-request.entity';
import { WorkSchedule } from './work-schedule.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  pwd: string;

  @Column({ default: false })
  is_complete: boolean;

  @OneToOne(() => UserDetails, (details) => details.user, { cascade: true })
  details: UserDetails;

  @OneToMany(() => WorkRequest, (workRequest) => workRequest.user)
  workRequests: WorkRequest[];

  @OneToMany(() => WorkSchedule, (workSchedule) => workSchedule.user)
  workSchedules: WorkSchedule[];
}
