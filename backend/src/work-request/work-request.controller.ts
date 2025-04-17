// backend/src/work-request/work-request.controller.ts
import { Controller, Post, Body, Request, UseGuards, Get, Param, Patch, Query } from '@nestjs/common';
import { WorkRequestService } from './work-request.service';
import { CreateWorkRequestDto } from './dto/create-work-request.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('work-request')
export class WorkRequestController {
  constructor(
    private readonly workRequestService: WorkRequestService
  ) {}

  // Endpoint đăng ký ca làm cho cả tuần
  @UseGuards(JwtAuthGuard)
  @Post('register')
  async registerWorkRequest(
    @Request() req,
    @Body() createDto: CreateWorkRequestDto,
  ) {
    console.log('[WorkRequestController] Received register request:', createDto);
    const userPayload = req.user;
    const workRequest = await this.workRequestService.createWorkRequest(userPayload, createDto);
    console.log('[WorkRequestController] Work request created:', workRequest);
    return { message: 'Work request registered successfully', data: workRequest };
  }

  @UseGuards(JwtAuthGuard)
  @Get('pending')
  async getPendingWorkRequests() {
    const pendingRequests = await this.workRequestService.getPendingRequests();
    console.log('[WorkRequestController] Pending work requests fetched:', pendingRequests);
    return { data: pendingRequests };
  }

  @UseGuards(JwtAuthGuard)
  @Patch('approve/:id')
  async approveWorkRequest(@Param('id') id: number) {
    console.log('[WorkRequestController] Approving work request id:', id);
    const result = await this.workRequestService.approveWorkRequest(id);
    return { message: 'Work request approved', data: result };
  }

  @UseGuards(JwtAuthGuard)
  @Patch('reject/:id')
  async rejectWorkRequest(
    @Param('id') id: number,
    @Body('reason') reason: string,
  ) {
    console.log('[WorkRequestController] Rejecting work request id:', id, 'with reason:', reason);
    const result = await this.workRequestService.rejectWorkRequest(id, reason);
    return { message: 'Work request rejected', data: result };
  }

    // Endpoint: GET /work-request/my-schedule?week_start=YYYY-MM-DD
  // Lấy lịch làm việc của user cho tuần hiện tại (pending, approved).
  @UseGuards(JwtAuthGuard)
  @Get('my-schedule')
  async getMySchedule(
    @Request() req,
    @Query('week_start') weekStart: string,
  ) {
    const userPayload = req.user; // Lấy thông tin user từ JWT
    const schedule = await this.workRequestService.getUserSchedule(
      userPayload.userId,
      new Date(weekStart),
    );
    return { data: schedule };
  }
}
