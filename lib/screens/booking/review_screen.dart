import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Import widget custom agar anti-lemot

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // 🚀 Logic: State untuk rating bintang dan input ulasan
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  // Simulasi data foto terlampir dengan link stabil
  final List<String> _attachedPhotos = [
    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
    'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400',
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Beri Ulasan',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Info Transaksi Card
            _buildTransactionCard(onSurfaceVariant),

            const SizedBox(height: 32),

            // 3. Rating Bintang
            _buildRatingSection(primaryColor, onSurfaceVariant),

            const SizedBox(height: 32),

            // 4. Input Ulasan Tertulis
            const _SectionLabel(label: 'ULASAN TERTULIS'),
            const SizedBox(height: 8),
            _buildReviewTextField(primaryContainer),

            const SizedBox(height: 32),

            // 5. Unggah Foto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _SectionLabel(label: 'LAMPIRAN FOTO'),
                Text('Maks. 3 foto',
                    style: TextStyle(
                        color: onSurfaceVariant,
                        fontSize: 11,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 12),
            _buildPhotoGrid(primaryColor),
          ],
        ),
      ),
      // 6. Sticky Footer
      bottomNavigationBar: _buildStickyFooter(primaryContainer),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTransactionCard(Color variant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            // 🚀 PERBAIKAN: Gunakan CustomNetworkImage
            child: const CustomNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
              width: 64,
              height: 64,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Penyewaan Alat',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1)),
                const Text('Tenda Eiger 4P',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    const Icon(Icons.store, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Toko Merdeka Outdoor',
                        style: TextStyle(color: variant, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(Color primary, Color variant) {
    return Column(
      children: [
        const Text(
          'Bagaimana kualitas alat & layanan Mitra?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () => setState(() => _selectedRating = index + 1),
              icon: Icon(
                index < _selectedRating ? Icons.star : Icons.star_outline,
                color: index < _selectedRating ? primary : Colors.grey.shade300,
                size: 40,
              ),
            );
          }),
        ),
        Text('Ketuk bintang untuk memberi nilai',
            style: TextStyle(color: variant, fontSize: 12)),
      ],
    );
  }

  Widget _buildReviewTextField(Color focusColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _reviewController,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: 'Ceritakan pengalamanmu menyewa alat di mitra ini...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(Color primary) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _attachedPhotos.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return InkWell(
            onTap: () {}, // Trigger Image Picker
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: Colors.grey),
                  SizedBox(height: 4),
                  Text('TAMBAH',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ),
          );
        }
        final photoUrl = _attachedPhotos[index - 1];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // 🚀 PERBAIKAN: Gunakan CustomNetworkImage
              child: CustomNetworkImage(
                  imageUrl: photoUrl,
                  width: double.infinity,
                  height: double.infinity),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () =>
                    setState(() => _attachedPhotos.removeAt(index - 1)),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStickyFooter(Color primaryContainer) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _selectedRating == 0
              ? null
              : () {
                  // 🚀 FIX: Navigasi ke '/dashboard' sesuai main.dart
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dashboard', (route) => false);
                },
          icon: const Icon(Icons.send, size: 18),
          label: const Text('Kirim Ulasan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
            elevation: 8,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: Colors.grey));
}
