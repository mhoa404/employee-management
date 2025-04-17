# Tổng quan  
HRM là một ứng dụng giúp quản lý nhân viên, được phát triển bằng Flutter và Firebase với cấu trúc dự án như sau
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

Dự án này nhằm mục đích phục vụ đồ án học tập
Nếu có vấn đề xin liên hệ:
mhoa.workspace@gmail.com

# Chức năng chính  
- Đăng ký, đăng nhập, đăng xuất  
- CRUD lịch làm
- Hỗ trợ nền tảng Mobile(Android) & Web  

# Công nghệ sử dụng  
- Flutter 
- Firebase (Authentication & Firestore)

# nestjs-flutter-testing2
# ktpm2
