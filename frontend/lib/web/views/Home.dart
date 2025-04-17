import 'package:error404project/common/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../common/widgets/ListOptionsWidget.dart';
import '../../common/widgets/GridHomePage.dart';

import '../../common/widgets/WebScheduleBox.dart';

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  Map<String, dynamic>? _currentUser;
  String selectedOption = 'Trang Chủ';
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final result = await authService.getCurrentUser();
    print("Current user response: $result");
    setState(() {
      _currentUser = (result != null && result.containsKey('user')) 
        ? result['user'] 
        : result;
    });
  }

  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 220,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }
  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 220,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: _currentUser!['details']?['avatar'] != null && _currentUser!['details']?['avatar'] != ''
              ? NetworkImage(_currentUser!['details']['avatar'])
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
                                      _currentUser!['details']?['full_name'] ?? 'Không có tên',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _currentUser!['details']?['department'] ?? 'Không có bộ phận',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListOptionsWidget(
                            icon: Icons.home,
                            title: 'Trang Chủ',
                            isSelected: selectedOption == 'Trang Chủ',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Trang Chủ';
                              });
                            },
                          ),
                          ListOptionsWidget(
                            icon: Icons.person,
                            title: 'Hồ sơ',
                            description: 'Thay đổi thông tin cá nhân',
                            isSelected: selectedOption == 'Hồ sơ',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Hồ sơ';
                              });
                            },
                          ),
                          ListOptionsWidget(
                            icon: Icons.lock,
                            title: 'Bảo mật',
                            description:
                                'Danh sách thiết bị đăng nhập, đổi mật khẩu',
                            isSelected: selectedOption == 'Bảo mật',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Bảo mật';
                              });
                            },
                          ),
                          ListOptionsWidget(
                            icon: Icons.notifications,
                            title: 'Cài đặt thông báo',
                            description: 'Tắt/bật các thông báo cần thiết',
                            isSelected:
                                selectedOption == 'Cài đặt thông báo',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Cài đặt thông báo';
                              });
                            },
                          ),
                          ListOptionsWidget(
                            icon: Icons.logout,
                            title: 'Đăng xuất',
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            onTap: () async {
                              authService.logout(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Colors.white,
                      child: selectedOption == 'Trang Chủ'
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Thêm dòng này để Column chỉ chiếm kích thước cần thiết
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back_ios),
                                        onPressed: scrollLeft,
                                      ),
                                      // Nếu kích thước bên trong có giới hạn cụ thể (height: 130) thì Expanded ở đây vẫn an toàn,
                                      // tuy nhiên bạn cũng có thể thay bằng Flexible nếu muốn:
                                      Expanded(
                                        child: SizedBox(
                                          height: 130,
                                          child: GestureDetector(
                                            onHorizontalDragUpdate: (details) {
                                              scrollController.jumpTo(
                                                scrollController.offset - details.primaryDelta!,
                                              );
                                            },
                                            child: ListView(
                                              controller: scrollController,
                                              scrollDirection: Axis.horizontal,
                                              physics: const BouncingScrollPhysics(),
                                              children: [
                                                GridItem(
                                                    icon: Icons.calendar_today,
                                                    title: 'Lịch làm việc',
                                                    subtitle: 'Ca làm việc và thay ca',
                                                    onTap: () {}),
                                                GridItem(
                                                    icon: Icons.work,
                                                    title: 'Công việc',
                                                    subtitle: 'Danh sách công việc',
                                                    onTap: () {}),
                                                GridItem(
                                                    icon: Icons.group,
                                                    title: 'Nhân sự',
                                                    subtitle: 'Quản lý nhân viên',
                                                    onTap: () {}),
                                                GridItem(
                                                    icon: Icons.assignment,
                                                    title: 'Báo cáo',
                                                    subtitle: 'Báo cáo công việc',
                                                    onTap: () {}),
                                                GridItem(
                                                    icon: Icons.rule,
                                                    title: 'Nội quy',
                                                    subtitle: 'Nội quy công việc',
                                                    onTap: () {}),
                                                GridItem(
                                                    icon: Icons.article,
                                                    title: 'Hướng dẫn',
                                                    subtitle: 'Sử dụng hệ thống',
                                                    onTap: () {}),
                                              ].map((item) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 10.0),
                                                  child: SizedBox(width: 150, child: item),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward_ios),
                                        onPressed: scrollRight,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const WebScheduleBox(),
                                ],
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Chức năng đang phát triển',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}