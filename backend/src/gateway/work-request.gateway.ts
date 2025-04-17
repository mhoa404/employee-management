// backend/src/gateway/work-request.gateway.ts
import { Logger } from '@nestjs/common';
import { WebSocketGateway, WebSocketServer, OnGatewayConnection, OnGatewayDisconnect, SubscribeMessage, MessageBody } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',  // Cấu hình CORS phù hợp nếu bạn chỉ định các origin cụ thể
  },
})
export class WorkRequestGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;
  private logger: Logger = new Logger('WorkRequestGateway');

  handleConnection(client: Socket) {
    this.logger.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  // Phương thức dùng để emit thông báo mới cho admin
  notifyNewRequest(workRequest: any) {
    // Giả sử sử dụng event 'newWorkRequest' để thông báo cho tất cả các client admin
    this.server.emit('newWorkRequest', workRequest);
    this.logger.log(`Emitted new work request to admin: ${JSON.stringify(workRequest)}`);
  }

  // (Tùy chọn) Xử lý các sự kiện khác từ client nếu cần
  @SubscribeMessage('registerWorkRequest')
  handleRegisterWorkRequest(@MessageBody() data: any): void {
    this.logger.log(`Received register work request: ${JSON.stringify(data)}`);
  }
}
