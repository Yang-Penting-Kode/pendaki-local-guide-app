import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedGender;

  // --- HELPER WIDGETS (Ditaruh di sini agar rapi) ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF6F7A6A),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint,
      {TextInputType? keyboardType, IconData? suffixIcon}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF6F7A6A).withOpacity(0.5)),
        fillColor: const Color(0xFFF3F3F3),
        filled: true,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: const Color(0xFF007A52))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown(List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          hint: const Text('Pilih Jenis Kelamin'),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF007A52);
    const Color secondaryColor = Color(0xFFFD8B00);
    const Color surfaceColor = Color(0xFFF9F9F9);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Akun Rental',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Konten Form yang bisa di-scroll
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Container(
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
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sewa Alat &\nCari Guide Lokal.',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 32),

                // Form Fields
                _buildLabel('Nama Lengkap'),
                _buildTextField('Contoh: Budi Santoso'),
                const SizedBox(height: 20),

                _buildLabel('Nomor HP'),
                _buildTextField('+62 812 3456 7890',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 20),

                _buildLabel('Nomor KTP'),
                _buildTextField('16 digit nomor identitas',
                    suffixIcon: Icons.photo_camera),
                const SizedBox(height: 20),

                _buildLabel('Jenis Kelamin'),
                _buildDropdown(['Laki-laki', 'Perempuan']),
                const SizedBox(height: 20),

                _buildLabel('Kontak Darurat'),
                _buildTextField('Nama & No. HP'),
                const SizedBox(height: 32),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user, color: primaryColor),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data Anda aman dan hanya digunakan untuk keperluan verifikasi sewa.',
                          style: TextStyle(fontSize: 11, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tombol Sticky di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white.withOpacity(0.9),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/verify-email');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
                child: const Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
