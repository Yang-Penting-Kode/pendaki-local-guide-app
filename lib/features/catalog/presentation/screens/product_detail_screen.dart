import 'dart:io';
import 'dart:ui';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late String _activeHeroImage;
  late List<String> _productImages;
  bool _isWishlisted = false;
  ProductVariantModel? _selectedVariant;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      ProductModel? product;
      if (args is ProductModel) {
        product = args;
      }
      if (product != null) {
        _activeHeroImage = product.imageUrl ?? 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=400';
        _productImages = [_activeHeroImage];
        _isWishlisted = StorageService.getWishlist().contains(product.id);
      }
      _isInit = true;
    }
  }

  bool _isLocalPath(String path) {
    return !path.startsWith('http://') && !path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    ProductModel? product;
    if (args is ProductModel) {
      product = args;
    }
    
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: Text('Data produk tidak tersedia.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, product),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Media Gallery View (Sejajar Sekuensial Form)
                    _buildImageGallerySection(),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Section Nama Produk
                          _buildSectionLabel('Nama Produk'),
                          const SizedBox(height: 8),
                          Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 32),

                          // 3. Section Kategori & Status Tag
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionLabel('Kategori'),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF3F3F3),
                                          borderRadius: BorderRadius.circular(99)),
                                      child: Text(product.categoryId.toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionLabel('Status Visibilitas'),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: product.stock > 0 ? const Color(0xFFC5ECD4) : const Color(0xFFEEEEEE),
                                          borderRadius: BorderRadius.circular(99)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                              product.stock > 0 ? Icons.check_circle_rounded : Icons.cancel,
                                              color: product.stock > 0 ? const Color(0xFF2B4E3C) : Colors.grey,
                                              size: 14),
                                          const SizedBox(width: 6),
                                          Text(
                                              product.stock > 0 ? 'Tersedia' : 'Habis',
                                              style: TextStyle(
                                                  color: product.stock > 0 ? const Color(0xFF2B4E3C) : Colors.grey,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // 4. Section Harga Sewa & Stok Utama
                          _buildSectionLabel('Harga Sewa Dasar / Hari'),
                          const SizedBox(height: 8),
                          _buildPricingCard(product),
                          const SizedBox(height: 32),

                          // 5. Tipe & Varian Terdaftar (Surgical Strike Variant Selector)
                          if (product.variants != null && product.variants!.isNotEmpty)
                            _buildVariantSelector(product),

                          // Spesifikasi Teknis
                          Visibility(
                            visible: product.capacity != null || product.weight != null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel('Spesifikasi Teknis'),
                                const SizedBox(height: 12),
                                _buildTechnicalSpecsGrid(product),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),

                          // 6. Section Deskripsi Produk
                          _buildSectionLabel('Deskripsi Produk'),
                          const SizedBox(height: 8),
                          Text(
                            product.description ?? '',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF3E4942),
                                height: 1.6,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 32),

                          // START REPLACE
                          // 7. Section Profil Toko
                          _buildStoreProfile(),
                          const SizedBox(height: 32),

                          // 8. Section Ulasan
                          _buildReviewSection(),
                          // END REPLACE
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFixedBottomActionBar(context, product),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ProductModel product) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF007A52)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Detail Produk',
        style: TextStyle(
            color: Color(0xFF007A52),
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(_isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? Colors.red : Colors.grey),
          onPressed: () async {
            final newValue = await StorageService.toggleWishlist(product.id);
            setState(() {
              _isWishlisted = newValue;
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(newValue ? 'Ditambahkan ke Wishlist' : 'Dihapus dari Wishlist'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade600,
          letterSpacing: 1.5),
    );
  }

  Widget _buildImageGallerySection() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLocalPath(_activeHeroImage)
                  ? Image.file(
                      File(_activeHeroImage),
                      key: ValueKey<String>(_activeHeroImage),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.network(
                      _activeHeroImage,
                      key: ValueKey<String>(_activeHeroImage),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 24,
            right: 24,
            child: Row(
              children: [
                ..._productImages.map((imageUrl) {
                  bool isActive = _activeHeroImage == imageUrl;
                  return GestureDetector(
                    onTap: () => setState(() => _activeHeroImage = imageUrl),
                    child: Container(
                      width: 56,
                      height: 56,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isActive ? Colors.white : Colors.transparent,
                            width: 2),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _isLocalPath(imageUrl)
                          ? Image.file(File(imageUrl), fit: BoxFit.cover)
                          : Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(ProductModel product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3).withOpacity(0.6),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp ${product.basePrice.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.5),
              ),
              const SizedBox(width: 4),
              const Text('/ hari',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xFFE2E2E2), width: 0.8))),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_rounded,
                    color: Color(0xFF436653), size: 18),
                const SizedBox(width: 8),
                Text('Stok Tersedia: ${product.stock}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(width: 6),
                Text('(Total: ${product.stock})',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // START REPLACE
  Widget _buildVariantSelector(ProductModel product) {
    if (product.variants == null || product.variants!.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('PILIHAN VARIAN'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: product.variants!.map((v) {
            final isSelected = _selectedVariant?.name == v.name;
            final priceText = v.additionalPrice > Decimal.zero ? ' (+ Rp ${v.additionalPrice.toStringAsFixed(0)})' : '';
            return ChoiceChip(
              label: Text('${v.name}$priceText'),
              selected: isSelected,
              selectedColor: const Color(0xFF007A52).withOpacity(0.2),
              onSelected: (selected) {
                setState(() {
                  _selectedVariant = selected ? v : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
  // END REPLACE

  Widget _buildTechnicalSpecsGrid(ProductModel product) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.9,
      children: [
        if (product.capacity != null) _specTile(Icons.group_outlined, 'KAPASITAS', product.capacity!),
        if (product.weight != null) _specTile(Icons.scale_outlined, 'BERAT', product.weight!),
      ],
    );
  }

  Widget _specTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 1.0)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildFixedBottomActionBar(BuildContext context, ProductModel product) {
    final totalPrice = product.basePrice + (_selectedVariant?.additionalPrice ?? Decimal.zero);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, -4))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HARGA / HARI',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Text('Rp ${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  width: 180,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF007A52)]),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.24),
                          blurRadius: 24,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(product, variant: _selectedVariant);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produk ditambahkan ke keranjang!'),
                          backgroundColor: AppColors.primary,
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: 18),
                    label: const Text('Tambah ke Keranjang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Informasi Mitra'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: const NetworkImage('https://picsum.photos/seed/store/100/100'),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Basecamp Gunung Gede',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Cibodas, Jawa Barat',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Kunjungi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionLabel('Ulasan Pelanggan'),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                const Text('4.8',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(' (124 Ulasan)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: const NetworkImage('https://picsum.photos/seed/user1/100/100'),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budi Santoso',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text('2 hari yang lalu',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                        5,
                        (index) => const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Barangnya bagus banget, kondisinya masih sangat prima. Penjual juga ramah dan responsif saat ditanya-tanya.',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3E4942),
                    height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
