import 'package:flutter/material.dart';
import '../../common/widgets/BoxTaskPage.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tác vụ'),
        backgroundColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5), // Set background color
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Section(
                title: 'Lịch làm việc',
                items: [
                  TaskItem(
                    icon: Icons.calendar_today,
                    label: 'Lịch làm việc chung',
                  ),
                  TaskItem(
                    icon: Icons.edit_calendar,
                    label: 'Đăng ký lịch làm việc',
                  ),
                ],
              ),
              Section(
                title: 'Chấm công',
                items: [
                  TaskItem(
                    icon: Icons.add,
                    label: 'Bổ sung/ sửa chấm công',
                  ),
                  TaskItem(
                    icon: Icons.device_hub,
                    label: 'Thiết bị chấm công',
                  ),
                ],
              ),
              Section(
                title: 'Lương',
                items: [
                  TaskItem(
                    icon: Icons.money,
                    label: 'Phiếu tạm ứng lương',
                  ),
                ],
              ),
              Section(
                title: 'Truyền thông nội bộ',
                items: [
                  TaskItem(
                    icon: Icons.article,
                    label: 'Tin tức',
                  ),
                  TaskItem(
                    icon: Icons.notifications,
                    label: 'Thông báo',
                  ),
                  TaskItem(
                    icon: Icons.rule,
                    label: 'Nội quy',
                  ),
                ],
              ),
              Section(
                title: 'Hướng dẫn sử dụng',
                items: [
                  TaskItem(
                    icon: Icons.article,
                    label: 'Câu hỏi thường gặp',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
