import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final List<TaskItem> items;

  const Section({Key? key, required this.title, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          Row(
            children: items,
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const TaskItem({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 6),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Color(0xFF1877F2)), // Facebook blue color
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

