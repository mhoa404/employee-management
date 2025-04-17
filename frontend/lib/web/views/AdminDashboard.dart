import 'package:flutter/material.dart';
import '../../common/services/auth_service.dart';
import '../../common/widgets/ListOptionsWidget.dart';
import 'AdminWorkRequest.dart';
import 'package:error404project/common/widgets/WebHomeContent.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _currentUser;
  String selectedOption = 'Trang Chủ';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final result = await authService.getCurrentUser();
    setState(() {
      _currentUser = (result != null && result.containsKey('user'))
          ? result['user']
          : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar
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
                                    image: _currentUser!['details']?['avatar'] != null &&
                                            _currentUser!['details']?['avatar'] != ''
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
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Trang quản lý',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                          icon: Icons.assignment,
                          title: 'Quản lý ca làm',
                          isSelected: selectedOption == 'Quản lý ca làm',
                          onTap: () {
                            setState(() {
                              selectedOption = 'Quản lý ca làm';
                            });
                          },
                        ),
                        ListOptionsWidget(
                          icon: Icons.people,
                          title: 'Quản Lý Nhân Viên',
                          isSelected: selectedOption == 'Quản Lý Nhân Viên',
                          onTap: () {
                            setState(() {
                              selectedOption = 'Quản Lý Nhân Viên';
                            });
                          },
                        ),
                        ListOptionsWidget(
                          icon: Icons.notifications,
                          title: 'Thông Báo',
                          isSelected: selectedOption == 'Thông Báo',
                          onTap: () {
                            setState(() {
                              selectedOption = 'Thông Báo';
                            });
                          },
                        ),
                        ListOptionsWidget(
                          icon: Icons.logout,
                          title: 'Đăng xuất',
                          iconColor: Colors.red,
                          textColor: Colors.red,
                          onTap: () {
                            authService.logout(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Content area
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.white,
                    child: selectedOption == 'Trang Chủ'
                        ? const WebHomeContent()
                        : selectedOption == 'Quản lý ca làm'
                            ? const AdminWorkRequests()
                            : Center(
                                child: Text(
                                  selectedOption,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                  ),
                ),
              ],
            ),
    );
  }
}
