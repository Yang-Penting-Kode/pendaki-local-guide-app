import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';
// START REPLACE
import 'package:pendaki_local_guide_app/features/settings/data/language_model.dart';
// END REPLACE

class SettingsProvider extends ChangeNotifier {
  String _currentLanguage = StorageService.getLanguage(); // Ambil bahasa dari storage saat inisialisasi

  String get currentLanguage => _currentLanguage;

  // Data sumber bahasa
  final List<LanguageModel> availableLanguages = [
    LanguageModel(
      name: 'Bahasa Indonesia',
      code: 'id',
      flagUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDDAWZhTJnMgQfWePKREMt26NTco2hweIJ-Ktg1ppZaqaRjIN7AG5dPNbE4fK-MN6dJWZeweoshWOMYNkTrhDLof_Psa23Uib-5dbHI2ioysF1zFtKH-GS5B_vBy6f28qwc3i85Elf0QDBQdkgFVsRXU_VrN5chYFtdQtMhxCia8WVcnl2M1kdOYobS6sMXFm9jKm5bgxpVvHgysACbzWT7nwUVff6kPgc4L-EqaYNEqm4otAgPo16IEwnIozNk1uaLEipuApY96Vxo',
    ),
    LanguageModel(
      name: 'English',
      code: 'en',
      flagUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD1mYT6sC7ZNNBixD1k6VLyrROWQhPBOw_XLmAEN04ZuCv9x9I23TC-jZBDHhJ7-PjG1_6PgBavdutU5XQSap9CDZE4oHnNXnnMkMgLTJMqijmqXyToOwXSn1sspxTp55fmfBkmn2FV4k2VTJ1QPg25yN-J94AC040jlCfP0UncwVqKY4b1CJVwQR_9vU7biFVt9BHn3xKLRC7WE5ssNtcz04kll7wgfviZiRePOlkRDr0_OUSf3PBtFe0d2h3s5RHBjEIBW3EPT1CC',
    ),
  ];

  void updateLanguage(String newLanguage) {
    _currentLanguage = newLanguage;
    StorageService.setLanguage(newLanguage);
    notifyListeners(); // Memicu UI untuk render ulang
  }
}
