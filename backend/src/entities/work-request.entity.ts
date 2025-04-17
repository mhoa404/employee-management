// backend/src/entities/work-request.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './user.entity';

@Entity('work_requests')
export class WorkRequest {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.workRequests)
  user: User;

  @Column({
    type: 'enum',
    enum: ['register', 'update', 'cancel'],
    default: 'register'
  })
  request_type: string;

  // Ngày bắt đầu của tuần (YYYY-MM-DD) mà người dùng đăng ký
  @Column({ type: 'date' })
  week_start: Date;

  // Lưu lịch đăng ký dạng JSON theo ngày, ví dụ:
  // { "2025-04-21": ["morning", "afternoon"], "2025-04-22": ["evening"], ... }
  @Column({ type: 'json' })
  schedule: any;

  // Lý do thay đổi/hủy (nếu có)
  @Column({ type: 'text', nullable: true })
  reason: string;

  // Trạng thái: 'pending', 'approved', 'rejected'
  @Column({
    type: 'enum',
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  })
  status: string;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updated_at: Date;
}
