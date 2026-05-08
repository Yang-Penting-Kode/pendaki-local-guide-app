import 'dart:ui';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // State untuk kontrol visibilitas password
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Controller untuk input
  final _currentPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void dispose() {
    _currentPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color secondaryColor = Color(0xFF006C0C);
    const Color secondaryContainer = Color(0xFF006C0C);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF228B22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Instructional Header
            _buildInstructionCard(primaryColor, onSurfaceVariant),

            const SizedBox(height: 40),

            // 3. Form Section
            _buildPasswordField(
              label: 'Kata Sandi Saat Ini',
              hint: 'Masukkan kata sandi lama',
              controller: _currentPwdController,
              isObscured: _obscureCurrent,
              onToggle: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 24),
            _buildPasswordField(
              label: 'Kata Sandi Baru',
              hint: 'Masukkan kata sandi baru',
              controller: _newPwdController,
              isObscured: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 24),
            _buildPasswordField(
              label: 'Konfirmasi Kata Sandi Baru',
              hint: 'Ulangi kata sandi baru',
              controller: _confirmPwdController,
              isObscured: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            const SizedBox(height: 48),

            // 4. Decorative Illustration
            _buildDecorativeIcon(),
          ],
        ),
      ),
      // 5. Sticky Footer CTA
      bottomNavigationBar:
          _buildBottomButton(secondaryColor, secondaryContainer),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildInstructionCard(Color primary, Color variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keamanan Akun',
            style: TextStyle(
                color: primary,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  color: variant,
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'Inter'),
              children: const [
                TextSpan(
                    text:
                        'Demi keamanan akun Anda, pastikan kata sandi baru memiliki minimal '),
                TextSpan(
                    text: '8 karakter',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: ' yang terdiri dari kombinasi '),
                TextSpan(
                    text: 'huruf dan angka',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF3F4A3B)),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          style:
              const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF006C0C), width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeIcon() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.grey.shade200, Colors.grey.shade50],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock_open_rounded,
          size: 120,
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildBottomButton(Color startColor, Color endColor) {
    return ClipRect(
      // 🚀 Tambahkan ClipRect agar blur tidak meluber
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10, sigmaY: 10), // 🚀 Gunakan ImageFilter.blur
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.7), // 🚀 Beri opasitas agar efek blur terlihat
            border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
          ),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [startColor, endColor]),
              borderRadius: BorderRadius.circular(99),
              boxShadow: [
                BoxShadow(
                    color: startColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Kata sandi berhasil diperbarui!'),
                      backgroundColor: Color(0xFF006C0C)),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save, size: 20),
              label: const Text('Simpan Kata Sandi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Manrope')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
