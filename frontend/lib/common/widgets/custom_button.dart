import 'package:flutter/material.dart';

Widget buildCustomButton({
  required String text,
  required VoidCallback onPressed,
  required Color backgroundColor,
  required Color textColor,
  Color? borderColor,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      foregroundColor: textColor,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
      ),
      minimumSize: const Size(100,50),
    ),
    child: Text(text),
  );
}
