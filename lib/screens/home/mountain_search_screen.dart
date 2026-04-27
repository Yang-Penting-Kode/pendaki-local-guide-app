import 'package:flutter/material.dart';
import '../../components/filter_modal.dart'; // 🚀 Import komponen filter

class MountainSearchScreen extends StatefulWidget {
  const MountainSearchScreen({super.key});

  @override
  State<MountainSearchScreen> createState() => _MountainSearchScreenState();
}

class _MountainSearchScreenState extends State<MountainSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk memanggil Bottom Sheet Filter
  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color outlineColor = Color(0xFF6F7A6A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRect(
          child: Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      size: 28, color: Color(0xFF1A1C1C)),
                  onPressed: () => Navigator.pop(context),
                ),
                // 1. Input Pencarian
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: outlineColor.withOpacity(0.15)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Ketik nama gunung...',
                        hintStyle:
                            TextStyle(color: outlineColor.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    size: 20, color: outlineColor),
                                onPressed: () =>
                                    setState(() => _searchController.clear()),
                              )
                            : null,
                      ),
                      onChanged: (value) => setState(() {}),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            '/mountain-search-result',
                            arguments: value,
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 2. Tombol Filter (Tune)
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: outlineColor.withOpacity(0.15)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: primaryColor, size: 20),
                    onPressed: () => _showFilter(context), // 🚀 Panggil modal
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Riwayat Pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Hapus Semua',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
            _buildHistoryItem('Gunung Arjuno'),
            _buildHistoryItem('Gunung Welirang'),
            _buildHistoryItem('Tenda Eiger'),

            const SizedBox(height: 32),

            // Pencarian Populer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Pencarian Populer',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildPopularChip(
                      Icons.local_fire_department, 'Gunung Semeru',
                      iconColor: Colors.orange),
                  _buildPopularChip(Icons.trending_up, 'Gunung Prau'),
                  _buildPopularChip(Icons.trending_up, 'Gunung Rinjani'),
                  _buildPopularChip(Icons.search, 'Carrier 60L'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildHistoryItem(String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, color: Color(0xFF6F7A6A)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Color(0xFF1A1C1C)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularChip(IconData icon, String label,
      {Color iconColor = Colors.grey}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
