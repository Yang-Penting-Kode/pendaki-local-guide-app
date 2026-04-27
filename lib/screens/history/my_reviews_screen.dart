import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna sesuai brand GuideIn
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // 1. TopAppBar Section
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulasan Saya',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
        child: Column(
          children: [
            // 2. Stats Summary Section
            _buildStatsSection(primaryColor),

            const SizedBox(height: 24),

            // 3. Reviews List
            _buildReviewCard(
              context,
              'Tenda Eiger 4P',
              '16 Ags 2024',
              'Tenda sangat kokoh saat badai di Merbabu. Bersih dan wangi saat diterima. Local guide sangat membantu proses setup awal. Sangat direkomendasikan!',
              5,
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              primaryColor,
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              context,
              'Sepatu Hiking Salomon',
              '10 Jul 2024',
              'Nyaman dipakai, grip masih sangat bagus. Hanya saja pengiriman agak terlambat sedikit dari jadwal booking awal. Tapi secara keseluruhan puas.',
              4,
              'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
              primaryColor,
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              context,
              'Carrier Osprey 65L',
              '22 Jun 2024',
              'Barang seperti baru! Beban terbagi dengan rata, punggung tidak sakit sama sekali walau mendaki 3 hari 2 malam. Terima kasih Local Guide!',
              5,
              'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400',
              primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildStatsSection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Ulasan',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              Text('24',
                  style: TextStyle(
                      color: primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 4),
                  const Text('4.9',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('Rata-rata Rating',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, String title, String date,
      String content, int rating, String imgUrl, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(
                  imageUrl: imgUrl,
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis)),
                        _buildStars(rating),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(content,
                        style: const TextStyle(
                            color: Color(0xFF3E4942),
                            fontSize: 13,
                            height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Hapus',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A52).withOpacity(0.1),
                  foregroundColor: primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Edit Ulasan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(int count) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 14,
        );
      }),
    );
  }
}
