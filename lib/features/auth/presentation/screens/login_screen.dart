// START REPLACE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../core/constants/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // State form lokal (Ephemeral State) — sesuai aturan Riverpod Do/Don'ts
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Hindari multiple clicks
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simulasi network delay sedikit untuk UX
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Panggil logika bisnis di Notifier
    final result = ref.read(authProvider.notifier).login(
          _emailCtrl.text,
          _passwordCtrl.text,
        );

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Email atau Password Salah'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Icon(Icons.landscape, color: AppColors.primary, size: 48),
              const SizedBox(height: 24),
              const Text(
                'Selamat Datang\nKembali!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk untuk melanjutkan petualanganmu.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 48),

              // Form Email
              const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'Masukkan email Anda',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // Form Password
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'Masukkan password Anda',
                controller: _passwordCtrl,
                isPassword: true,
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              
              // Lupa Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // TODO: Fase selanjutnya
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Login
              PrimaryButton(
                text: 'Masuk',
                isLoading: _isLoading,
                onTap: _handleLogin,
              ),
              const SizedBox(height: 24),

              // Daftar Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register-marketplace');
                    },
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
// END REPLACE
