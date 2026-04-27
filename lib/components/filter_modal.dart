import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  double _maxPrice = 50000;
  final List<String> _selectedCategories = ['Tenda', 'Carrier'];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48, height: 6,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text('Filter Pencarian', 
                  style: TextStyle(fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                const Text('Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: [
                    _buildFilterChip('Tenda', Icons.campaign, _selectedCategories.contains('Tenda')),
                    _buildFilterChip('Carrier', Icons.backpack, _selectedCategories.contains('Carrier')),
                    _buildFilterChip('Sepatu', Icons.hiking, false),
                    _buildFilterChip('Matras', Icons.bed, false),
                    _buildFilterChip('Sleeping Bag', Icons.hotel, false),
                  ],
                ),

                const SizedBox(height: 32),

                // Slider Harga
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Harga Maksimal', style: TextStyle(fontWeight: FontWeight.bold)),
                          RichText(text: TextSpan(
                            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                            children: [
                              TextSpan(text: 'Rp ${(_maxPrice / 1000).toStringAsFixed(0)}k '),
                              const TextSpan(text: '/ hari', style: TextStyle(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.normal)),
                            ]
                          )),
                        ],
                      ),
                      Slider(
                        value: _maxPrice,
                        min: 10000, max: 200000,
                        activeColor: primaryColor,
                        onChanged: (value) => setState(() => _maxPrice = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
            child: Row(
              children: [
                Expanded(flex: 3, child: TextButton(onPressed: () {}, child: const Text('Hapus', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 16),
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                    ),
                    child: const Text('Tampilkan 8 Mitra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isActive) {
    const Color primaryColor = Color(0xFF006C0C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isActive ? const LinearGradient(colors: [primaryColor, Color(0xFF1C871E)]) : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: isActive ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isActive ? Colors.white : Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}