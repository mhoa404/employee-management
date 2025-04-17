// backend/src/work-request/dto/create-work-request.dto.ts
export class CreateWorkRequestDto {
  readonly request_type: 'register' | 'update' | 'cancel';
  // Ngày bắt đầu của tuần theo định dạng "YYYY-MM-DD"
  readonly week_start: string;
  // Lịch đăng ký dưới dạng JSON với key là ngày (YYYY-MM-DD)
  readonly schedule: Record<string, string[]>;
  readonly reason?: string;
}
