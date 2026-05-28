import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Mapping warna dari Tailwind Config
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryColor = Color(0xFF904D00); // Safety Orange
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set New Password',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1C),
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // 1. Asymmetrical Header Section
              const Text(
                'Atur Sandi Baru',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 280,
                child: Text(
                  'Buat kata sandi baru yang kuat untuk akun Anda.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 2. Form Section
              _buildLabel('KATA SANDI BARU'),
              _buildPasswordField(
                isVisible: _isNewPasswordVisible,
                onToggle: () => setState(
                    () => _isNewPasswordVisible = !_isNewPasswordVisible),
              ),
              const SizedBox(height: 32),

              _buildLabel('KONFIRMASI KATA SANDI'),
              _buildPasswordField(
                isVisible: _isConfirmPasswordVisible,
                onToggle: () => setState(() =>
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
              const SizedBox(height: 24),

              // 3. Password Requirements checklist
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: const Border(
                    left: BorderSide(color: primaryColor, width: 4),
                  ),
                ),
                child: Column(
                  children: [
                    _buildRequirement(
                        Icons.check_circle, 'Minimal 8 karakter', true),
                    const SizedBox(height: 8),
                    _buildRequirement(Icons.radio_button_unchecked,
                        'Gunakan kombinasi angka & simbol', false),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 4. Main Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Munculkan feedback sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Kata sandi berhasil diperbarui! Silahkan masuk.'),
                        backgroundColor: Color(0xFF006C0C),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    // 2. 🚀 Tendang balik ke Login dan hapus semua history navigasi
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    elevation: 8,
                    shadowColor: secondaryColor.withOpacity(0.2),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Simpan Kata Sandi',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              // 5. Atmospheric Illustration
              const SizedBox(height: 60),
              const Center(
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.landscape, size: 120, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Label Pattern
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3F4A3B),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // Helper: Ghost Input Pattern
  Widget _buildPasswordField(
      {required bool isVisible, required VoidCallback onToggle}) {
    return TextField(
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: '********',
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBECAB7), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: const Color(0xFFBECAB7).withOpacity(0.2)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
          color: Colors.black45,
        ),
      ),
    );
  }

  // Helper: Requirement Row
  Widget _buildRequirement(IconData icon, String text, bool isDone) {
    return Row(
      children: [
        Icon(icon,
            size: 18, color: isDone ? const Color(0xFF006C0C) : Colors.black26),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDone
                ? const Color(0xFF3F4A3B)
                : const Color(0xFF3F4A3B).withOpacity(0.5),
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
