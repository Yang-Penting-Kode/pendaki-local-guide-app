import 'package:flutter/material.dart';
// START REPLACE
import 'package:pendaki_local_guide_app/features/settings/data/language_model.dart';
// END REPLACE
// START REPLACE
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';
// END REPLACE

class LanguageModal extends StatefulWidget {
  final String initialLanguage;
  final List<LanguageModel> languages;
  final Function(String) onLanguageSelected;

  const LanguageModal({
    super.key,
    required this.initialLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageModal> createState() => _LanguageModalState();
}

class _LanguageModalState extends State<LanguageModal>
    with SingleTickerProviderStateMixin {
  late String _tempLanguage;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _tempLanguage = widget.initialLanguage;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 24),
          const Text('Pilih Bahasa',
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          ...widget.languages.map((lang) {
            bool isSelected = _tempLanguage == lang.name;
            return _buildTile(lang, isSelected, primaryColor);
          }),
          const SizedBox(height: 24),
          _buildBouncyButton(primaryColor),
        ],
      ),
    );
  }

  Widget _buildTile(LanguageModel lang, bool isSelected, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _tempLanguage = lang.name),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF3F3F3) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? primary : Colors.grey.shade200,
                width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              ClipOval(
                  child: CustomNetworkImage(
                      imageUrl: lang.flagUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover)),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(lang.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16))),
              if (isSelected) Icon(Icons.check_circle, color: primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBouncyButton(Color primary) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onLanguageSelected(_tempLanguage);
        Navigator.pop(context);
      },
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [primary, const Color(0xFF1C871E)]),
            borderRadius: BorderRadius.circular(99),
          ),
          alignment: Alignment.center,
          child: const Text('Simpan Perubahan',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      ),
    );
  }
}
