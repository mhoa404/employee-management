// backend/src/work-request/work-request.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkRequest } from '../entities/work-request.entity';
import { WorkSchedule } from '../entities/work-schedule.entity';
import { User } from '../entities/user.entity';
import { WorkRequestService } from './work-request.service';
import { WorkRequestController } from './work-request.controller';
import { WorkRequestGateway } from '../gateway/work-request.gateway';

@Module({
  imports: [TypeOrmModule.forFeature([WorkRequest, WorkSchedule, User])],
  providers: [WorkRequestService, WorkRequestGateway],
  controllers: [WorkRequestController],
  exports: [WorkRequestService],
})
export class WorkRequestModule {}
