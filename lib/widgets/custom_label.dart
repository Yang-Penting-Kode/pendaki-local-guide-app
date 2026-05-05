import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart'; // 🚀 Pastikan path ini benar

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color:
              AppColors.onSurfaceVariant, // Menggunakan konstanta warna global
        ),
      ),
    );
  }
}
