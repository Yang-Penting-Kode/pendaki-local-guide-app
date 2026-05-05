import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../screens/home/basecamp_partners_screen.dart';

class DatePickerModal extends StatefulWidget {
  const DatePickerModal({super.key});

  @override
  State<DatePickerModal> createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  int? startDayIndex;
  int? endDayIndex;

  void _onDateTap(int index) {
    setState(() {
      if (startDayIndex == null ||
          (startDayIndex != null && endDayIndex != null)) {
        startDayIndex = index;
        endDayIndex = null;
      } else if (index > startDayIndex!) {
        endDayIndex = index;
      } else {
        startDayIndex = index;
      }
    });
  }

  String _formatDisplayDate(int? index) {
    if (index == null) return "-";
    int day = index - 3;
    return "$day Okt 2023";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pilih Tanggal Sewa',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close,
                      color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildDateInfo(
                          'TANGGAL MULAI',
                          _formatDisplayDate(startDayIndex),
                          Icons.calendar_today),
                      const SizedBox(width: 16),
                      _buildDateInfo(
                          'TANGGAL BERAKHIR',
                          _formatDisplayDate(endDayIndex),
                          Icons.calendar_month),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildCalendarHeader('Oktober 2023'),
                  const SizedBox(height: 24),
                  _buildCalendarGrid(),
                  const SizedBox(height: 40),

                  // 🚀 FIX: Menggunakan fungsi anonim agar tidak melanggar aturan non-nullable
                  PrimaryButton(
                    text: 'Terapkan Tanggal',
                    onTap: () {
                      if (startDayIndex != null && endDayIndex != null) {
                        _navigateToPartners(context);
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  const Opacity(
                    opacity: 0.6,
                    child: Text(
                      '*Harga dapat berubah sewaktu-waktu tergantung ketersediaan alat pendakian.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPartners(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(
        // 🚀 FIX: Ganti placeholder kemarin dengan Class Screen yang asli
        pageBuilder: (context, animation, secondaryAnimation) =>
            const BasecampPartnersScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeOutQuart;

          var tweetTranslation = animation.drive(
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve)),
          );
          var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: tweetTranslation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  // --- UI HELPERS TETAP SAMA ---
  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisSpacing: 8),
      itemCount: 35,
      itemBuilder: (context, index) {
        if (index < 4) return const SizedBox();
        bool isStart = index == startDayIndex;
        bool isEnd = index == endDayIndex;
        bool isInRange = startDayIndex != null &&
            endDayIndex != null &&
            index > startDayIndex! &&
            index < endDayIndex!;
        return GestureDetector(
            onTap: () => _onDateTap(index),
            child: _buildDateCell(index, isStart, isEnd, isInRange));
      },
    );
  }

  Widget _buildDateCell(int index, bool isStart, bool isEnd, bool isInRange) {
    String dayText = "${index - 3}";
    if (isStart) return _buildSelectedDay(dayText, isStart: true);
    if (isEnd) return _buildSelectedDay(dayText, isEnd: true);
    if (isInRange) return _buildRangeDay(dayText);
    return Center(child: Text(dayText, style: const TextStyle(fontSize: 14)));
  }

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(date,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(String month) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(month,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Row(children: [
          Icon(Icons.chevron_left, color: Colors.grey),
          SizedBox(width: 16),
          Icon(Icons.chevron_right, color: Colors.grey)
        ]),
      ],
    );
  }

  Widget _buildSelectedDay(String day,
      {bool isStart = false, bool isEnd = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (startDayIndex != null && endDayIndex != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.horizontal(
                left: isEnd ? Radius.zero : const Radius.circular(99),
                right: isStart ? Radius.zero : const Radius.circular(99),
              ),
            ),
          ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
          child: Center(
              child: Text(day,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  Widget _buildRangeDay(String day) {
    return Container(
      color: AppColors.primaryContainer.withOpacity(0.2),
      child: Center(
          child: Text(day,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimaryFixedVariant))),
    );
  }
}
