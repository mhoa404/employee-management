// backend/src/work-request/work-request.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateWorkRequestDto } from './dto/create-work-request.dto';
import { WorkRequest } from '../entities/work-request.entity';
import { WorkSchedule } from '../entities/work-schedule.entity';
import { User } from '../entities/user.entity';
import { WorkRequestGateway } from '../gateway/work-request.gateway';

@Injectable()
export class WorkRequestService {
  private readonly logger = new Logger(WorkRequestService.name);
  
  constructor(
    @InjectRepository(WorkRequest)
    private readonly workRequestRepository: Repository<WorkRequest>,
    @InjectRepository(WorkSchedule)
    private readonly workScheduleRepository: Repository<WorkSchedule>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly workRequestGateway: WorkRequestGateway,
  ) {}

  async createWorkRequest(userPayload: any, dto: CreateWorkRequestDto): Promise<WorkRequest> {
    const userId = userPayload.userId; // Lấy từ JWT payload
    this.logger.debug(`Creating work request for user id: ${userId}`);
  
    // Lấy user đầy đủ từ DB để đảm bảo có trường id và các mối quan hệ cần thiết.
    const fullUser = await this.userRepository.findOne({ where: { id: userId }, relations: ['details'] });
    if (!fullUser) {
      throw new Error(`User with id ${userId} not found`);
    }
  
    // Kiểm tra dữ liệu `schedule` có đúng định dạng hay không.
    if (!dto.schedule || typeof dto.schedule !== 'object') {
      throw new Error('Invalid schedule format');
    }
  
    const workRequest = this.workRequestRepository.create({
      user: fullUser,
      request_type: dto.request_type,
      week_start: new Date(dto.week_start),
      schedule: dto.schedule,
      reason: dto.reason,
      status: 'pending',
    });
  
    const savedRequest = await this.workRequestRepository.save(workRequest);
    this.logger.debug(`Work request created: ${JSON.stringify(savedRequest)}`);
    // Emit thông báo realtime cho admin qua WebSocket
    this.workRequestGateway.notifyNewRequest(savedRequest);
    return savedRequest;
  }
  

  async approveWorkRequest(requestId: number): Promise<WorkRequest> {
    this.logger.debug(`Approving work request id: ${requestId}`);
    const request = await this.workRequestRepository.findOne({
      where: { id: requestId },
      relations: ['user']
    });
    if (!request) {
      throw new Error('Work request not found');
    }
    request.status = 'approved';
    const savedRequest = await this.workRequestRepository.save(request);
    // Cập nhật (hoặc tạo mới) lịch làm việc chính thức dựa trên request đã duyệt
    let workSchedule = await this.workScheduleRepository.findOne({
      where: { user: { id: request.user.id }, week_start: request.week_start }
    });
    if (!workSchedule) {
      workSchedule = this.workScheduleRepository.create({
        user: request.user,
        week_start: request.week_start,
        schedule: request.schedule
      });
    } else {
      workSchedule.schedule = request.schedule;
    }
    await this.workScheduleRepository.save(workSchedule);
    this.logger.debug(`Work request approved and schedule updated for user: ${request.user.id}`);
    // (Có thể emit sự kiện cho user biết rằng yêu cầu đã được duyệt nếu cần)
    return savedRequest;
  }

  async rejectWorkRequest(requestId: number, reason: string): Promise<WorkRequest> {
    this.logger.debug(`Rejecting work request id: ${requestId} with reason: ${reason}`);
    const request = await this.workRequestRepository.findOne({ where: { id: requestId } });
    if (!request) {
      throw new Error('Work request not found');
    }
    request.status = 'rejected';
    request.reason = reason;
    const savedRequest = await this.workRequestRepository.save(request);
    this.logger.debug(`Work request rejected: ${JSON.stringify(savedRequest)}`);
    // (Có thể emit thông báo cho user)
    return savedRequest;
  }

  async getPendingRequests(): Promise<WorkRequest[]> {
    const pending = await this.workRequestRepository.find({
      where: { status: 'pending' },
      relations: ['user', 'user.details']
    });
    this.logger.debug(`Fetched pending work requests: ${JSON.stringify(pending)}`);
    return pending;
  }

  // Lấy lịch làm việc của user theo tuần hiện tại.
  async getUserSchedule(userId: number, weekStart: Date): Promise<Record<string, Record<string, string>>> {
    // Truy vấn tất cả các yêu cầu ca làm của user cho tuần `weekStart`
    const workRequests = await this.workRequestRepository.find({
      where: { user: { id: userId }, week_start: weekStart },
    });
  
    // Nếu không có dữ liệu, trả về lịch rỗng.
    if (!workRequests || workRequests.length === 0) {
      this.logger.debug(`No work requests found for user ${userId} and week ${weekStart}`);
      return {};
    }
  
    // Xây dựng lịch làm việc dựa trên dữ liệu truy vấn.
    const schedule: Record<string, Record<string, string>> = {};
    for (const request of workRequests) {
      // Đảm bảo rằng `schedule` là JSON hợp lệ.
      if (request.schedule && typeof request.schedule === 'object') {
        for (const [date, periods] of Object.entries(request.schedule as Record<string, string[]>)) {
          if (!schedule[date]) {
            schedule[date] = {};
          }
          for (const period of periods) {
            schedule[date][period] = request.status; // Trạng thái: "pending", "approved"
          }
        }
      } else {
        this.logger.warn(`Invalid schedule format for request id ${request.id}`);
      }
    }
    this.logger.debug(`User schedule for week ${weekStart}: ${JSON.stringify(schedule)}`);
    return schedule;
  }
}
