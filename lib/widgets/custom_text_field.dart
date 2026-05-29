import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final IconData? suffixIcon;
  final IconData? prefixIcon; // 🚀 Tambah prefix icon untuk search
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final double borderRadius; // 🚀 Tambah fleksibilitas radius
  final EdgeInsetsGeometry? contentPadding; // 🚀 Tambah fleksibilitas padding
  final bool showShadow; // 🚀 Bisa matikan/hidupkan shadow
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixTap,
    this.keyboardType,
    this.borderRadius = 16.0,
    this.contentPadding,
    this.showShadow = true,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
          // 🚀 Gunakan padding kustom jika ada, jika tidak pakai default formulir
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.primary, size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: AppColors.primary),
                  onPressed: onSuffixTap,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
