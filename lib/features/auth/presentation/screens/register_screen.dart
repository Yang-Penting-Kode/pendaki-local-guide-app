// START REPLACE
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
  final _formKey = GlobalKey<FormState>(); // 🚀 Injeksi GlobalKey
  String? _selectedGender;
  bool _isLoading = false;
  File? _ktpImage;
  File? _profileImage; // 🚀 Injeksi Profile Image

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

  Future<void> _pickKtpImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _ktpImage = File(pickedFile.path);
      });
    }
  }

  // 🚀 Tambahan picker untuk Profile Image
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Profile Avatar (Menggantikan Hero Image)
                  _buildProfileAvatar(),
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
                    hint: 'Contoh: Budi Santoso', 
                    controller: _nameController,
                    validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

// START REPLACE
                const CustomLabel(text: 'Alamat Email'),
                CustomTextField(
                    hint: 'customer@gmail.com', 
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Password'),
                CustomTextField(
                    hint: 'secret#123', 
                    controller: _passwordController, 
                    isPassword: true,
                    validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Konfirmasi Password'),
                CustomTextField(
                    hint: 'secret#123', 
                    controller: _confirmPasswordController, 
                    isPassword: true,
                    validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),
// END REPLACE

                const CustomLabel(text: 'Nomor HP'),
                CustomTextField(
                  hint: '+62 812 3456 7890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                const CustomLabel(text: 'Upload Foto KTP'),
                GestureDetector(
                  onTap: _pickKtpImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
                    ),
                    child: _ktpImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_ktpImage!, fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: AppColors.primary, size: 40),
                              SizedBox(height: 8),
                              Text('Tap untuk upload foto KTP', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

// START REPLACE
                const CustomLabel(text: 'Jenis Kelamin'),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text('Pilih Jenis Kelamin'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                  ],
                  validator: (value) => value == null ? 'Pilih jenis kelamin' : null,
                  onChanged: (newValue) => setState(() => _selectedGender = newValue),
                ),
// END REPLACE
                const SizedBox(height: 20),

// START REPLACE
                const CustomLabel(text: 'Kontak Darurat'),
                CustomTextField(
                    hint: 'Nama', controller: _emergencyNameController),
                const SizedBox(height: 20),
                CustomTextField(
                    hint: 'No. HP', 
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
// END REPLACE

                // 3. Info Card Keamanan
                _buildSecurityInfo(),
                ],
              ),
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
                  // 🚀 START REPLACE (Validasi & Auth)
                  if (!_formKey.currentState!.validate()) return;
                  
                  if (_isLoading) return;
                  setState(() => _isLoading = true);

                  final result = ref.read(authProvider.notifier).register(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                    phoneNumber: _phoneController.text.trim(),
                    gender: _selectedGender,
                    emergencyName: _emergencyNameController.text.trim(),
                    emergencyPhone: _emergencyPhoneController.text.trim(),
                    ktpPhotoUrl: _ktpImage?.path,
                    profilePhotoUrl: _profileImage?.path, // 🚀 Inject Photo Profile URL
                  );

                  setState(() => _isLoading = false);

                  if (result.isSuccess) {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.message ?? 'Gagal mendaftar'), backgroundColor: Colors.red),
                    );
                  }
                  // 🚀 END REPLACE
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

  Widget _buildProfileAvatar() {
    return Center(
      child: GestureDetector(
        onTap: _pickProfileImage,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.05),
            border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
          ),
          child: _profileImage != null
              ? ClipOval(
                  child: Image.file(_profileImage!, fit: BoxFit.cover, width: 120, height: 120),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: AppColors.primary, size: 32),
                    SizedBox(height: 4),
                    Text('Upload\nAvatar', textAlign: TextAlign.center, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
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
