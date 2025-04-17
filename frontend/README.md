# Frontend
## Overview
lib/  
│── common/
│   │── controllers/  
│   │   │── route_manager.dart -> Quản lý điều hướng  
│   │── services/  
│   │   │── authentication.dart -> Xử lý xác thực người dùng   
│   │── widgets/  
│   │   ├── BottomNavBarWidget.dart -> Thanh điều hướng  
│   │   ├── BoxTaskPage.dart -> Box trong TaskPage(Mobile)  
│   │   ├── GridHomePage.dart -> Lưới trong HomePage(Mobile)  
│   │   ├── ListOptionsWidget.dart -> Tùy chọn ở trang Manage  
│   │   ├── custom_button.dart -> Nút login/register  
│   │   ├── WebScheduleBox.dart -> Form lịch làm  
│   │   ├── WebHomeContent.dart -> Admin Home Widget  
│── img/
│── mobile/  
│   │── views/  
│   │   ├── WelcomePage.dart -> chào mừng khi mở ứng dụng.  
│   │   ├── HomePage.dart -> Trang chủ.  
│   │   ├── LoginPage.dart -> Màn hình đăng nhập.  
│   │   ├── RegisPage.dart -> Màn hình đăng ký tài khoản.  
│   │   ├── CompleteProfilePage.dart -> Hoàn tất hồ sơ cá nhân sau khi đăng ký.  
│   │   ├── NotificationPage.dart -> Thông báo.  
│   │   ├── ManagePage.dart -> Quản lý tùy chọn  
│   │   ├── TaskPage.dart -> Danh sách công việc.  
│   │   ├── WorkSchedulePage.dart -> Lịch làm việc.  
│── web/  
│   │── views/  
│   │   │── Home.dart -> Trang chủ   
│   │   │── WebLogin.dart -> Trang đăng nhập  
│   │   │── WebRegister.dart -> Trang đăng ký tài khoản   
│── firebase_config.dart -> Cấu hình Firebase cho ứng dụng.  
│── main.dart -> Điểm khởi chạy chính  

## Features
- Đăng ký, đăng nhập, đăng xuất  
- CRUD lịch làm
- Hỗ trợ nền tảng Mobile(Android) & Web
## Executing program
Chạy frontend (mobile):
```
cd frontend
flutter pub get
flutter run
```

## Authors
[Lê Nguyễn Minh Hòa](https://github.com/mhoa404)  



