import 'package:flutter/material.dart';

class ListOptionsWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool? isSelected; // Thêm thuộc tính isSelected

  const ListOptionsWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    this.iconColor,
    this.textColor,
    this.onTap,
    this.isSelected, // Đánh dấu là required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor ?? Colors.black,
                          fontWeight: (isSelected ?? false) ? FontWeight.bold : FontWeight.normal,


                        ),
                      ),
                      if (description != null)
                        Text(
                          description!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
