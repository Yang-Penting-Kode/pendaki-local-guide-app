import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9).withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF005307)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About App',
          style: TextStyle(
            color: Color(0xFF005307),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // 2. Logo & Version Section
            _buildHeaderSection(),

            const SizedBox(height: 48),

            // 3. Description Section
            _buildDescriptionCard(onSurfaceVariant),

            const SizedBox(height: 32),

            // 4. Links Section
            _buildLinksSection(primaryColor),

            const SizedBox(height: 64),

            // 5. Atmospheric Banner
            _buildAtmosphericBanner(),

            const SizedBox(height: 48),

            // 6. Footer
            const Text(
              '© 2024 LOCAL GUIDE INDONESIA. ALL RIGHTS RESERVED.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.2,
                color: Color(0x993F4A3B),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 12),
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: const CustomNetworkImage(
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCxImCuYUUB-mTNf3hdiiPM751OGURNsS63uxHFID7K8dzDcgftuB7eFEYvvnymnNUeSI2-97AMcMEGOLw63Zuc-hEFxbK93Gr5RqIpk-zt2SK2opABuefaWoEw0GmvqvzYeJ_Fv3BG2OTVicKJ8LaKirY4WnhL1vDuKmPl6YtoeoOFUBiA5GRpr1iw3BgS8piptZ1U-LZ-uLNwEePytH_D89UQ2ymup4_58hy4CK7C5GVoGVB8eadxSj1tnTsmoJ0pllfmPzcih9Ih',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Local Guide',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            'Versi 2.4.1 (Alpine Edition)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3F4A3B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Text(
        'Local Guide adalah marketplace rental alat outdoor terpercaya yang menghubungkan pendaki dengan mitra rental lokal di seluruh Nusantara. Kami berdedikasi untuk memberikan akses perlengkapan berkualitas tinggi demi keamanan dan kenyamanan petualangan Anda di alam liar.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildLinksSection(Color primary) {
    return Column(
      children: [
        _buildLinkItem(Icons.language, 'Kunjungi Situs Web', primary,
            onTap: () {}),
        _buildLinkItem(Icons.camera_alt, 'Instagram', primary, onTap: () {}),
        _buildLinkItem(Icons.mail, 'Hubungi Kami', primary, onTap: () {}),
        _buildLinkItem(Icons.star, 'Beri Rating di Play Store', primary,
            isFilled: true, onTap: () {}),
      ],
    );
  }

  Widget _buildLinkItem(IconData icon, String title, Color primary,
      {bool isFilled = false, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: primary,
                  size: 24,
                  shadows: isFilled
                      ? [const Shadow(color: Colors.black12, blurRadius: 4)]
                      : null),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFFBECAB7), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAtmosphericBanner() {
    return Container(
      height: 256,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC4YAZLCKGXjavvOW91WpNyeapAU4HTl5XyLwaIEassM61Ec1EbJuILhIUbto3mFf2_2RqWktMLzH7jRsICqM5XtVWjdRbfq5j2PwCvfAbYSRvRSA8vp7ie0PL40vE6zj0Wh04kghwizK7dSWlBhq3QCP7gQRumMjdvCbHRAOXZUnq0WDMXmMk7f4EgYZ1tqHiNVm3wYaXW_v5nXzeSfRnrXxAM92v1nWyGn4PddlkP6aM_ym1hFhUjPxpnE7gVdsOm1NJxNYioE3Vx',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
          const Positioned(
            bottom: 32,
            left: 32,
            child: Text(
              'Mendaki Lebih Jauh,\nMenjelajah Lebih Aman.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
