import 'package:flutter/material.dart';

class WebHomeContent extends StatelessWidget {
  const WebHomeContent({super.key});

  void _onAddPressed() {
    // Chỉ demo UI: in ra console
    print("Add button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Box 1: Tổng kết tuần
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tổng kết tuần",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20, color: Colors.blue),
                      onPressed: _onAddPressed,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Nội dung tạm thời (placeholder)
                const Text(
                  "Chưa có dữ liệu",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          // Box 2: Ca làm nhân viên
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ca làm nhân viên",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20, color: Colors.blue),
                      onPressed: _onAddPressed,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Nội dung dạng List - hiện tại chưa có dữ liệu nên hiển thị thông báo
                SizedBox(
                  height: 300, // Giới hạn chiều cao để tránh lỗi layout
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 0, // chưa có dữ liệu, thay thế bằng số lượng item khi có dữ liệu
                    itemBuilder: (context, index) {
                      // Chưa có nội dung, có thể hiển thị thông tin ca làm khi cần
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Thêm các box khác nếu cần...
        ],
      ),
    );
  }
}