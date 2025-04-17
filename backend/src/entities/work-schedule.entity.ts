// backend/src/entities/work-schedule.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './user.entity';

@Entity('work_schedules')
export class WorkSchedule {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.workSchedules)
  user: User;

  // Ngày bắt đầu của tuần được duyệt
  @Column({ type: 'date' })
  week_start: Date;

  // Lưu lịch làm việc chính thức dưới dạng JSON, ví dụ:
  // { "2025-04-21": ["morning", "afternoon"], "2025-04-22": ["evening"], ... }
  @Column({ type: 'json' })
  schedule: any;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updated_at: Date;
}
