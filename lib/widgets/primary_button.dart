import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart'; // 🚀 Merujuk ke pusat warna

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isLoading; // 🔄 Untuk feedback saat klik login/daftar

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.isLoading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 🎾 Inisialisasi efek pegas (Gojek Style)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05, // Mengecil 5% saat ditekan
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.isLoading ? null : _controller.forward(),
      onTapUp: (_) {
        if (!widget.isLoading) {
          _controller.reverse();
          widget.onTap();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(99),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppColors.primary).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
