import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/modals/filter_modal.dart';
import '../../widgets/custom_text_field.dart';

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

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;

    // Simulasi: Jika mengetik "kosong", arahkan ke SearchNotFoundScreen
    if (query.toLowerCase() == 'kosong') {
      Navigator.pushNamed(context, '/search-empty');
    } else {
      Navigator.pushNamed(context, '/mountain-search-result', arguments: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              // 🚀 FIX: Padding yang lebih pas agar tidak terlalu rapat atau terlalu lebar
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back,
                        size: 24, color: AppColors.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      hint: 'Ketik nama gunung...',
                      controller: _searchController,
                      borderRadius: 99, // 🚀 Bikin lonjong sempurna
                      showShadow: false, // 🚀 Matikan shadow agar AppBar bersih
                      // 🚀 FIX: Padding dikurangi agar teks tidak "terhimpit" vertikal
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      onChanged: (value) => setState(() {}),
                      onSubmitted: _handleSearch,
                      // Logika ikon hapus (X) di kanan
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Icons.close
                          : null,
                      onSuffixTap: () {
                        _searchController.clear();
                        setState(
                            () {}); // 👈 Refresh UI agar ikon X langsung hilang
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Riwayat Pencarian',
                      style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Pencarian Populer',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildHistoryItem(String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, size: 20, color: AppColors.outline),
            const SizedBox(width: 16),
            Expanded(
                child: Text(text,
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.onSurface))),
            const Icon(Icons.north_west_rounded,
                size: 16, color: AppColors.outline),
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
