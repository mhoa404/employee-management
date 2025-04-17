
# Employee Management System
Dự án tổng hợp phục vụ đồ án kết thúc học phần kiểm thử phần mềm 2 của nhóm Error404.  
## Description
Hệ thống quản lý nhân viên theo loại ứng dụng đơn tổ chức (Single Organization System), tức là chỉ có một tổ chức chủ quản và nhân viên được cấp phép hoặc đăng ký tài khoản để truy cập vào hệ thống làm việc.
## Getting Started
### Dependencies
Java JDK 17+  
Node.js 16+  
MySQL & MySQL Workbench  
### Installing
`git clone https://github.com/mhoa404/employee-management`  
`cd employee-management`  
### Setup database managemet
1. Vào MySQL Workbench tạo DB:
```
create database employee-management;
use employee-management;
```
2. Chỉnh sửa file `.env` trong backend:
Đổi tên người dùng và mật khẩu khớp với tài khoản cá nhân (mặc định là root)
### Executing program
1. Chạy backend:
```
cd backend
npm install
npm run start:dev 
```
2. Chạy frontend (mobile):
```
cd frontend
flutter pub get
flutter run
```
3. Chạy frontend (web):
``` 
cd web
npm install
npm start dev
```
## Authors
[Lê Nguyễn Minh Hòa](https://github.com/mhoa404)  
[Nguyễn Đăng Khoa](https://github.com/DangKhoa2410)  
Phan Xuân Cường  
Nguyễn Văn Hoàng  
Phạm Khả Nam