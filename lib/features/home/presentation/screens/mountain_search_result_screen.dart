import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/utils/geolocation_utils.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_text_field.dart';

class MountainSearchResultScreen extends StatefulWidget {
  final String searchQuery;

  const MountainSearchResultScreen({super.key, required this.searchQuery});

  @override
  State<MountainSearchResultScreen> createState() =>
      _MountainSearchResultScreenState();
}

class _MountainSearchResultScreenState
    extends State<MountainSearchResultScreen> {
  late TextEditingController _searchController;
  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.searchQuery;
    _searchController = TextEditingController(text: _currentQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchRefresh(String query) {
    if (query.trim().isEmpty) return;
    if (query.toLowerCase() == 'kosong') {
      Navigator.pushReplacementNamed(context, '/search-empty');
    } else {
      setState(() {
        _currentQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    MountainData? mountain;
    
    if (rawArgs is MountainData) {
      mountain = rawArgs;
    } else if (rawArgs is String) {
      mountain = GeolocationUtils.mountainList.firstWhere(
        (m) => m.name.toLowerCase().contains(rawArgs.toLowerCase()),
        orElse: () => GeolocationUtils.mountainList.first,
      );
    } else {
      mountain = GeolocationUtils.mountainList.first; // Fallback absolut
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        // 🚀 FIX: Search Bar interaktif di hasil pencarian
        title: CustomTextField(
          hint: 'Cari gunung lain...',
          controller: _searchController,
          borderRadius: 99,
          showShadow: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          prefixIcon: Icons.search,
          onSubmitted: _handleSearchRefresh,
          suffixIcon: _searchController.text.isNotEmpty ? Icons.close : null,
          onSuffixTap: () => setState(() => _searchController.clear()),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetaInfo(),
            const SizedBox(height: 24),
            _buildMountainResultCard(
              context,
              mountain: mountain,
              title: mountain?.name ?? 'Gunung Arjuno via Tretes',
              location: mountain?.location ?? 'Pasuruan, Jawa Timur',
              elevation: mountain?.elevation ?? '3.339 mdpl',
              difficulty: mountain?.difficulty ?? 'SULIT',
              rentalCount: 12,
              imageUrl: mountain?.imageUrl ??
                  'https://picsum.photos/seed/axrbmh/600/400',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              fontFamily: 'Inter'),
          children: [
            const TextSpan(text: 'Menampilkan hasil untuk '),
            TextSpan(
              text: '"$_currentQuery"',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMountainResultCard(
    BuildContext context, {
    MountainData? mountain,
    required String title,
    required String location,
    required String elevation,
    required String difficulty,
    required int rentalCount,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/mountain-detail', arguments: {
        'title': title,
        'location': location,
        'imageUrl': imageUrl,
        'mountain': mountain, // 🚀 Sertakan objek mountain ke detail
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.surfaceContainerLow,
                          child: const Icon(Icons.broken_image))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Manrope')),
                      const SizedBox(height: 8),
                      _buildIconText(Icons.location_on_outlined, location),
                      _buildIconText(Icons.landscape_outlined, elevation),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/basecamp-partners', arguments: mountain),
              child: Row(
                children: [
                  const Icon(Icons.storefront_outlined,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('$rentalCount Mitra Rental di sekitar basecamp',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(color: AppColors.outline, fontSize: 12)),
      ],
    );
  }
}
