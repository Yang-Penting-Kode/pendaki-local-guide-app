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

  // 🚀 OPTIMASI: Logika tap yang lebih ramping
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
          // Handle modal bar statis (Gunakan const)
          const _ModalHandle(),
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
              // 🚀 OPTIMASI: Tambahkan physics agar scroll di VIVO lebih mulus
              physics: const BouncingScrollPhysics(),
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
                  const _CalendarHeader(month: 'Oktober 2023'),
                  const SizedBox(height: 24),
                  _buildCalendarGrid(),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    text: 'Terapkan Tanggal',
                    // Tombol hanya aktif jika range sudah dipilih
                    onTap: (startDayIndex != null && endDayIndex != null)
                        ? () => _navigateToPartners(context)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const _DisclaimerText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- OPTIMIZED UI HELPERS ---

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisSpacing: 8),
      itemCount: 35,
      itemBuilder: (context, index) {
        if (index < 4) return const SizedBox.shrink();

        final bool isStart = index == startDayIndex;
        final bool isEnd = index == endDayIndex;
        final bool isInRange = startDayIndex != null &&
            endDayIndex != null &&
            index > startDayIndex! &&
            index < endDayIndex!;

        return _DateCell(
          index: index,
          isStart: isStart,
          isEnd: isEnd,
          isInRange: isInRange,
          onTap: () => _onDateTap(index),
        );
      },
    );
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

  void _navigateToPartners(BuildContext context) {
    Navigator.pop(context, {
      'startDate': startDayIndex,
      'endDate': endDayIndex,
    });
  }
}

// 🚀 EXTRA OPTIMIZATION: Pisahkan widget statis agar tidak kena rebuild setState

class _ModalHandle extends StatelessWidget {
  const _ModalHandle();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final String month;
  const _CalendarHeader({required this.month});
  @override
  Widget build(BuildContext context) {
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
}

class _DateCell extends StatelessWidget {
  final int index;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final VoidCallback onTap;

  const _DateCell({
    required this.index,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String dayText = "${index - 3}";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isInRange || isStart || isEnd)
            Container(
              margin: EdgeInsets.only(
                left: isStart ? 20 : 0,
                right: isEnd ? 20 : 0,
              ),
              decoration: BoxDecoration(
                color: (isInRange || isStart || isEnd)
                    ? AppColors.primaryContainer.withOpacity(0.2)
                    : Colors.transparent,
              ),
            ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  (isStart || isEnd) ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                dayText,
                style: TextStyle(
                  color: (isStart || isEnd) ? Colors.white : Colors.black,
                  fontWeight: (isStart || isEnd || isInRange)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerText extends StatelessWidget {
  const _DisclaimerText();
  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.6,
      child: Text(
        '*Harga dapat berubah sewaktu-waktu tergantung ketersediaan alat pendakian.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
