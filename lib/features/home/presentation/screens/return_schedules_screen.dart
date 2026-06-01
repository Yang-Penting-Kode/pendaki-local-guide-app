import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';

class ReturnSchedulesScreen extends ConsumerWidget {
  const ReturnSchedulesScreen({super.key});

  /// Cek apakah rentang berakhir <= 1 hari dari sekarang (urgent)
  bool _isUrgent(DateTime rentalEnd) {
    final diff = rentalEnd.difference(DateTime.now());
    return diff.inDays <= 1;
  }

  /// Format DateTime ke "dd Mmm yyyy"
  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  /// Format date untuk section title "Hari ini / dd Mmm yyyy"
  String _buildSectionLabel(DateTime endDate) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
    final diff = endDateOnly.difference(todayDate).inDays;
    
    if (diff == 0) return 'Hari Ini, ${_formatDate(endDate)}';
    if (diff == 1) return 'Besok, ${_formatDate(endDate)}';
    if (diff < 0) return 'Terlambat (${_formatDate(endDate)})';
    
    return _formatDate(endDate);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryColor = Color(0xFF007A52);
    const Color backgroundColor = Color(0xFFF8FAF9);
    const Color textOnSurface = Color(0xFF191C1C);
    const Color textVariant = Color(0xFF6E7A72);
    const Color outlineVariant = Color(0xFFBDC9C0);
    const Color surfaceContainerLow = Color(0xFFF2F4F3);

    final ordersAsync = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textOnSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Pengembalian',
          style: TextStyle(
            color: textOnSurface,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final returnOrders = orders.where((o) => 
            o.status == OrderStatus.activeRental || o.status == OrderStatus.readyForReturn
          ).toList();
          
          returnOrders.sort((a, b) => a.rentalEndDate.compareTo(b.rentalEndDate));

          if (returnOrders.isEmpty) {
            return _buildEmptyState(context, primaryColor);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: returnOrders.length,
            itemBuilder: (context, index) {
              final order = returnOrders[index];
              final sectionLabel = _buildSectionLabel(order.rentalEndDate);
              
              bool showSectionLabel = false;
              if (index == 0) {
                showSectionLabel = true;
              } else {
                final prevOrder = returnOrders[index - 1];
                final prevSectionLabel = _buildSectionLabel(prevOrder.rentalEndDate);
                if (sectionLabel != prevSectionLabel) {
                  showSectionLabel = true;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSectionLabel) ...[
                    if (index > 0) const SizedBox(height: 24),
                    _buildSectionTitle(sectionLabel, textVariant),
                    const SizedBox(height: 16),
                  ],
                  _buildScheduleCard(
                    context: context,
                    order: order,
                    primaryColor: primaryColor,
                    outlineVariant: outlineVariant,
                    surfaceContainerLow: surfaceContainerLow,
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 64,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Belum ada jadwal\npengembalian',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191C1C),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kamu belum menyewa peralatan apapun saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: Color(0xFF6E7A72),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required BuildContext context,
    required OrderModel order,
    required Color primaryColor,
    required Color outlineVariant,
    required Color surfaceContainerLow,
  }) {
    final urgent = _isUrgent(order.rentalEndDate);
    final timeLabel = urgent ? 'Sebelum akhir hari ini' : 'Tanggal ${_formatDate(order.rentalEndDate)}';
    final status = urgent ? 'Segera Dikembalikan' : 'Menunggu Pengembalian';
    
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/order-detail', arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: urgent ? Colors.red.withOpacity(0.3) : outlineVariant.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER: ID & Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: urgent ? const Color(0xFFFFF5F5) : surfaceContainerLow,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: urgent ? Colors.red.withOpacity(0.1) : outlineVariant.withOpacity(0.3))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID TRANSAKSI',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: urgent ? Colors.red.shade700 : const Color(0xFF3E4942),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#${order.id.split('-').last}',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: urgent ? Colors.red.shade900 : const Color(0xFF191C1C),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: urgent ? Colors.red.shade50 : const Color(0xFFE6F2ED),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: urgent ? Colors.red.withOpacity(0.2) : primaryColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: urgent ? Colors.red.shade700 : primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // WAKTU KEMBALI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: urgent ? Colors.red : const Color(0xFF6E7A72)),
                  const SizedBox(width: 8),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: urgent ? Colors.red : const Color(0xFF6E7A72),
                    ),
                  ),
                ],
              ),
            ),

            // NESTED ITEMS (ORDER.ITEMS)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4F3),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: const NetworkImage('https://picsum.photos/seed/rental/200/200'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF191C1C),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12,
                                  color: Color(0xFF6E7A72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
