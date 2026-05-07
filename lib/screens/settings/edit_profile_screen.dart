import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller untuk input data
  final TextEditingController _nameController =
      TextEditingController(text: 'Adi Chandra Isro\' Salsabilla');
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _emailController =
      TextEditingController(text: 'adi.chandra@email.com');
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();

  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryContainer = Color.fromARGB(255, 80, 172, 5);
    const Color onSecondaryContainer = Color.fromARGB(255, 238, 237, 236);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          children: [
            // 2. Profile Picture Section
            _buildProfileImagePicker(primaryColor),

            const SizedBox(height: 40),

            // 3. Basic Info Section
            _buildInputField(
                label: 'NAMA LENGKAP',
                controller: _nameController,
                hint: 'Masukkan nama lengkap'),
            const SizedBox(height: 20),
            _buildInputField(
                label: 'NOMOR HP',
                controller: _phoneController,
                hint: 'Masukkan nomor handphone',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            _buildInputField(
                label: 'ALAMAT EMAIL',
                controller: _emailController,
                hint: 'contoh@email.com',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),

            // Gender Dropdown
            _buildGenderDropdown(onSurfaceVariant, primaryColor),

            const SizedBox(height: 20),
            _buildInputField(
                label: 'NAMA KONTAK DARURAT',
                controller: _emergencyNameController,
                hint: 'Nama Lengkap Kontak'),
            const SizedBox(height: 20),
            _buildInputField(
                label: 'KONTAK DARURAT',
                controller: _emergencyPhoneController,
                hint: '+62 812 0000 0000',
                keyboardType: TextInputType.phone),
          ],
        ),
      ),
      // 4. Sticky Action Button
      bottomNavigationBar:
          _buildBottomAction(secondaryContainer, onSecondaryContainer),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildProfileImagePicker(Color primary) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEEEEEE), width: 4),
              ),
              child: const ClipOval(
                child: CustomNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1527631746610-bca00a040d60?q=80&w=400',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Ubah Foto Profil',
            style: TextStyle(
                color: primary, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildInputField(
      {required String label,
      required TextEditingController controller,
      required String hint,
      TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3F4A3B),
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF006C0C), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown(Color variant, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('JENIS KELAMIN',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3F4A3B),
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Pilih Jenis Kelamin',
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary, width: 2)),
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
            DropdownMenuItem(value: 'female', child: Text('Perempuan')),
          ],
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
      ],
    );
  }

  Widget _buildBottomAction(Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Simulasi simpan data
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profil berhasil diperbarui!'),
                  backgroundColor: Color(0xFF006C0C)),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: textColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          ),
          child: const Text('SIMPAN PERUBAHAN',
              style: TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
        ),
      ),
    );
  }
}
