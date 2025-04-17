import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../common/widgets/ListOptionsWidget.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập userData
    final userData = {
      'name': 'Nguyễn Văn A',
      'profileImage': null, // Có thể là Uint8List nếu có ảnh
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: userData['profileImage'] != null
                                ? MemoryImage(userData['profileImage'] as Uint8List)
                                : const AssetImage('lib/img/default-user-avt.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? 'Không có tên',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Chỉnh sửa thông tin cá nhân',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),

            // List Section
            Expanded(
              child: Column(
                children: [
                  const ListOptionsWidget(
                    icon: Icons.lock,
                    title: 'Bảo mật',
                    description: 'Danh sách thiết bị đăng nhập, đổi mật khẩu',
                    isSelected: false,
                  ),
                  const ListOptionsWidget(
                    icon: Icons.notifications,
                    title: 'Cài đặt thông báo',
                    description: 'Tắt/bật các thông báo cần thiết',
                    isSelected: false,
                  ),
                  const ListOptionsWidget(
                    icon: Icons.feedback,
                    title: 'Đóng góp ý kiến, báo lỗi',
                    description: 'Đóng góp ý kiến, báo lỗi',
                    isSelected: false,
                  ),
                  const ListOptionsWidget(
                    icon: Icons.group,
                    title: 'Group HRM trên Facebook',
                    description: 'Cộng đồng trao đổi, tư vấn kinh nghiệm',
                    isSelected: false,
                  ),
                  const ListOptionsWidget(
                    icon: Icons.swap_horiz,
                    title: 'Chuyển tài khoản',
                    description: 'Có thể đăng nhập nhiều tài khoản...',
                    isSelected: false,
                  ),
                  ListOptionsWidget(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      // TODO: Thêm hành động đăng xuất nếu cần
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ],
              ),
            ),

            // Bottom Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HRM Nhân Viên v2.8.8'),
                      Text('Powered by iPOS.vn'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.flag),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
