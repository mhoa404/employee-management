import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/BottomNavBarWidget.dart';
import '../../common/widgets/GridHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, dynamic>? userData;

  String _getGreeting() {
    int hour = DateTime.now().hour;
    return hour < 10
        ? 'Chào buổi sáng'
        : hour < 13
        ? 'Chào buổi trưa'
        : hour < 18
        ? 'Chào buổi chiều'
        : 'Chào buổi tối';
  }

  LinearGradient _getGradient() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFF4682B4), Color(0xFF1E90FF), Color(0xFF4169E1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (hour < 13) {
      return const LinearGradient(
        colors: [Color(0xFFFF8C00), Color(0xFFFFA500), Color(0xFFFF8C00), Color(0xFFFF4500)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (hour < 18) {
      return const LinearGradient(
        colors: [Color(0xFF6A5ACD), Color(0xFF7B68EE), Color(0xFF8470FF), Color(0xFF4169E1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF220E53), Color(0xFF403883), Color(0xFF4D4898), Color(0xFF3A335F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return WillPopScope(
        onWillPop: () async {
      return false; // Chặn back button khi ở trang Home
    },
    child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 170, // Chiều cao của phần đầu trước khi thu nhỏ
              floating: false,
              pinned: false, // Giữ lại một phần nhỏ khi cuộn
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                      gradient: _getGradient(),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('lib/img/default-user-avt.png'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData?['name'] ?? 'Không có tên',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    userData?['department'] ?? 'Không có bộ phận',
                                    style: const TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            'Chúc bạn một ngày làm việc hiệu quả',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Nút chấm công (GIỮ NGUYÊN UI)
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6C4CF7),
                      Color(0xFF3D54D6),
                      Color(0xFF115EAD),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Row(
                    
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('lib/img/click.png'),
                        backgroundColor: Color(0xFFFFFFF),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chấm công',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Để bắt đầu công việc thôi nào!',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // GridView chứa các tính năng
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  GridItem(
                    icon: Icons.calendar_today,
                    title: 'Lịch làm việc',
                    subtitle: 'Ca làm việc và thay ca',
                    onTap: () {
                      context.push('/work-schedule');
                    },
                  ),
                  GridItem(icon: Icons.beach_access, title: 'Đăng ký nghỉ', subtitle: 'Nghỉ ngày, nghỉ ca', onTap: () {}),
                  GridItem(icon: Icons.access_time, title: 'Số giờ làm việc', subtitle: '89 giờ', onTap: () {}),
                  GridItem(icon: Icons.announcement, title: 'Bảng tin', subtitle: '0 tin tức', onTap: () {}),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Công việc cần làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('Xem lịch sử')),
                ],
              ),

              const Center(
                child: Column(
                  children: [
                    Text('Không có công việc cần làm', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(currentIndex: 0),
    ),
    );
  }
}