// START REPLACE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_label.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/primary_button.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 🎮 Controllers untuk data pendaftaran
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ktpController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _ktpController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }
// END REPLACE

  // 🛠️ Fungsi pemicu Kamera untuk KTP
  void _handleKTPAction() {
    // 📸 Di sini nanti kita pasang ImagePicker di Phase 3
    print("Membuka Kamera/Galeri untuk Foto KTP...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur Kamera akan segera aktif!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daftar Akun Rental'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                24, 24, 24, 150), // Padding bawah extra untuk tombol sticky
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Section
                _buildHeroImage(),
                const SizedBox(height: 24),
                const Text(
                  'Sewa Alat &\nCari Guide Lokal.',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 32),

                // 2. Form Fields (Menggunakan Widget Global)
                const CustomLabel(text: 'Nama Lengkap'),
                CustomTextField(
                    hint: 'Contoh: Budi Santoso', controller: _nameController),
                const SizedBox(height: 20),

// START REPLACE
                const CustomLabel(text: 'Alamat Email'),
                CustomTextField(
                    hint: 'customer@gmail.com', controller: _emailController),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Password'),
                CustomTextField(
                    hint: 'secret#123', controller: _passwordController, isPassword: true),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Konfirmasi Password'),
                CustomTextField(
                    hint: 'secret#123', controller: _confirmPasswordController, isPassword: true),
                const SizedBox(height: 20),
// END REPLACE

                const CustomLabel(text: 'Nomor HP'),
                CustomTextField(
                  hint: '+62 812 3456 7890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Nomor KTP'),
                CustomTextField(
                  hint: '16 digit nomor identitas',
                  controller: _ktpController,
                  suffixIcon: Icons.photo_camera,
                  onSuffixTap: _handleKTPAction, // 🚀 Trigger aksi kamera
                ),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Jenis Kelamin'),
                CustomDropdown(
                  value: _selectedGender,
                  hint: 'Pilih Jenis Kelamin',
                  items: const ['Laki-laki', 'Perempuan'],
                  onChanged: (newValue) =>
                      setState(() => _selectedGender = newValue),
                ),
                const SizedBox(height: 20),

// START REPLACE
                const CustomLabel(text: 'Kontak Darurat'),
                CustomTextField(
                    hint: 'Nama', controller: _emergencyNameController),
                const SizedBox(height: 20),
                CustomTextField(
                    hint: 'No. HP', controller: _emergencyPhoneController),
                const SizedBox(height: 32),
// END REPLACE

                // 3. Info Card Keamanan
                _buildSecurityInfo(),
              ],
            ),
          ),

          // 4. Tombol Sticky dengan Efek Bouncy
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
// START REPLACE
              child: PrimaryButton(
                text: 'Daftar Sekarang',
                color: AppColors.primary, // Warna Orange untuk pendaftaran
                isLoading: _isLoading,
                onTap: () {
                  if (_isLoading) return;
                  setState(() => _isLoading = true);

                  String mergedPhone = _phoneController.text.trim();
                  if (_emergencyNameController.text.isNotEmpty || _emergencyPhoneController.text.isNotEmpty) {
                    mergedPhone += " (Darurat: ${_emergencyNameController.text.trim()} - ${_emergencyPhoneController.text.trim()})";
                  }

                  final result = ref.read(authProvider.notifier).register(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                    phoneNumber: mergedPhone,
                  );

                  setState(() => _isLoading = false);

                  if (result.isSuccess) {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.message ?? 'Gagal mendaftar'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
// END REPLACE
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS (Hanya yang sangat spesifik) ---

  Widget _buildHeroImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1533626904905-cc52fd99285e?q=80&w=1000'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Data Anda aman dan hanya digunakan untuk keperluan verifikasi sewa.',
              style: TextStyle(fontSize: 11, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
