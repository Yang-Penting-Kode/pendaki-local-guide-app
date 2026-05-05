import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart'; // 🚀 Gunakan warna global
import '../../components/modals/filter_modal.dart'; // 🚀 Sesuaikan path folder modals

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
    return Scaffold(
      backgroundColor: AppColors.surface, // ⚪ Konsisten dengan tema
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80), // 🚀 FIX: Batasi tinggi AppBar agar aman
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 24, color: AppColors.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // 1. Input Pencarian (Safe Constraints)[cite: 7, 10]
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                            color: AppColors.outline.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Ketik nama gunung...',
                          hintStyle: TextStyle(
                              color: AppColors.outline.withOpacity(0.6)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () =>
                                      setState(() => _searchController.clear()),
                                  child: const Icon(Icons.close,
                                      size: 18, color: AppColors.outline),
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
                  const SizedBox(width: 12),
                  // 2. Tombol Filter
                  GestureDetector(
                    onTap: () => _showFilter(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.outline.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Riwayat Pencarian[cite: 10]
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Hapus',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
            _buildHistoryItem('Gunung Arjuno'),
            _buildHistoryItem('Gunung Welirang'),
            _buildHistoryItem('Tenda Eiger'),

            const SizedBox(height: 32),

            // Pencarian Populer[cite: 10]
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Pencarian Populer',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
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
      onTap: () {
        _searchController.text = text;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, size: 20, color: AppColors.outline),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 15, color: AppColors.onSurface)),
            ),
            const Icon(Icons.north_west_rounded,
                size: 16,
                color: AppColors.outline), // Ikon panah ala Google Search
          ],
        ),
      ),
    );
  }

  Widget _buildPopularChip(IconData icon, String label,
      {Color iconColor = AppColors.outline}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
