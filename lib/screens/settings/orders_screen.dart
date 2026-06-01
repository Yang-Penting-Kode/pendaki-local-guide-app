import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text_field.dart'; // 🚀 Import CustomTextField

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifikasi',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                Text('Tandai Dibaca',
                    style: TextStyle(
                        color: Color(0xFF006C0C),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    _buildNotifItem(
                        Icons.inventory_2,
                        'Peralatan Siap!',
                        'Tenda Eiger 4P Anda sudah bisa diambil di Basecamp.',
                        '2 Menit Lalu',
                        true),
                    _buildNotifItem(
                        Icons.campaign,
                        'Promo Spesial',
                        'Diskon rental 20% khusus pendakian akhir pekan!',
                        '1 Jam Lalu',
                        false),
                    _buildNotifItem(
                        Icons.wb_sunny,
                        'Info Cuaca',
                        'Cuaca Semeru hari ini terpantau cerah berawan.',
                        '3 Jam Lalu',
                        false),
                    _buildNotifItem(
                        Icons.verified,
                        'Verifikasi Berhasil',
                        'Akun Anda telah terverifikasi untuk sewa pro.',
                        'Kemarin',
                        false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifItem(
      IconData icon, String title, String sub, String time, bool isNew) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew
            ? const Color(0xFF006C0C).withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: const Color(0xFF006C0C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(sub,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12, height: 1.4)),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(
                        color: Colors.black26,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isNew)
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.orange, shape: BoxShape.circle)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Pesanan & Penyewaan',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF228B22)),
            onPressed: () => _showNotificationModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF228B22),
              unselectedLabelColor: onSurfaceVariant,
              indicatorColor: const Color(0xFF228B22),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              tabs: const [
                Tab(text: 'Aktif'),
                Tab(text: 'Riwayat'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveOrders(context, primaryColor, onSurfaceVariant),
                const Center(child: Text('Belum ada riwayat pesanan')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrders(
      BuildContext context, Color primary, Color variant) {
    return ListView(
      physics: const BouncingScrollPhysics(), // 🚀 Smooth scrolling untuk VIVO
      padding: const EdgeInsets.all(24),
      children: [
        // 🚀 IMPLEMENTASI: CustomTextField
        CustomTextField(
          hint: 'Cari pesanan...',
          controller: _searchController,
          prefixIcon: Icons.search,
          borderRadius: 12,
          showShadow: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const SizedBox(height: 32),

        _buildOrderCard(
          context,
          title: 'Tenda Eiger 4P Waterproof',
          status: 'Siap Diambil',
          date: '14 - 16 Ags',
          location: 'Basecamp Semeru',
          price: 'Rp 100.000',
          imageUrl:
              'https://picsum.photos/seed/p0qffl/600/400',
          statusColor: const Color(0xFF006C0C),
          buttonText: 'Detail',
          isGradientButton: true,
        ),
        const SizedBox(height: 24),
        _buildOrderCard(
          context,
          title: 'Carrier Osprey 65L Premium',
          status: 'Sedang Disewa',
          date: '12 - 15 Ags',
          location: 'Dikirim Kurir',
          price: 'Rp 120.000',
          imageUrl:
              'https://picsum.photos/seed/f8ra1w/600/400',
          statusColor: Colors.blue.shade700,
          buttonText: 'Lacak',
          isGradientButton: false,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildBentoUpsell('Asuransi', 'Lindungi pendakianmu.',
                  Icons.shield, const Color(0xFF228B22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSupportCard(primary),
            ),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String title,
    required String status,
    required String date,
    required String location,
    required String price,
    required String imageUrl,
    required Color statusColor,
    required String buttonText,
    required bool isGradientButton,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(
                    imageUrl: imageUrl, width: 70, height: 70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'Manrope')),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(99)),
                          child: Text(status,
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildIconText(Icons.calendar_today, date),
                    const SizedBox(height: 4),
                    _buildIconText(Icons.location_on, location),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      fontFamily: 'Manrope')),
              // 🚀 PERBAIKAN: Kirim context ke button action
              _buildActionButton(context, buttonText, isGradientButton),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, bool isGradient) {
    return Container(
      decoration: isGradient
          ? BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF006C0C), Color(0xFF1C871E)]),
              borderRadius: BorderRadius.circular(99),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF006C0C).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            )
          : null,
      child: ElevatedButton(
        onPressed: () {
          // 🚀 LOGIKA NAVIGASI DINAMIS
          if (text == 'Detail') {
            Navigator.pushNamed(context, '/pickup-confirmation');
          } else if (text == 'Lacak') {
            Navigator.pushNamed(context, '/live-tracking');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isGradient ? Colors.transparent : const Color(0xFFEEEEEE),
          foregroundColor: isGradient ? Colors.white : const Color(0xFF3F4A3B),
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        ),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildBentoUpsell(
      String label, String title, IconData icon, Color color) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          Positioned(
              right: -10,
              bottom: -10,
              child: Icon(icon, size: 60, color: color.withOpacity(0.1))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(),
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, height: 1.2)),
              const Spacer(),
              Row(
                children: [
                  Text('Info',
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                  Icon(Icons.arrow_forward, color: color, size: 12),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(Color primary) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bantuan?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Text('Hubungi CS',
              style: TextStyle(color: Colors.grey, fontSize: 11)),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE), shape: BoxShape.circle),
              child: Icon(Icons.support_agent, color: primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
