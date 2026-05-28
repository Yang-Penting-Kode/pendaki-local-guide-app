// fix_imports.dart
// Jalankan dengan: dart fix_imports.dart
// Tujuan: Memperbaiki semua import yang rusak akibat migrasi path

import 'dart:io';

void main() {
  final projectRoot = Directory('lib');
  int fileCount = 0;
  int fixCount = 0;

  // Peta penggantian: key = pola lama, value = pola baru
  final replacements = <String, String>{
    // --- Services yang dipindahkan ke core ---
    "import 'package:pendaki_local_guide_app/services/storage_services.dart';":
        "import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';",
    "import 'package:pendaki_local_guide_app/services/auth_service.dart';":
        "import 'package:pendaki_local_guide_app/core/network/auth_service.dart';",

    // --- Providers yang dipindahkan ke features ---
    "import 'package:pendaki_local_guide_app/providers/settings_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart';",
    "import 'package:pendaki_local_guide_app/providers/onboarding_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/onboarding/providers/onboarding_provider.dart';",

    // --- Relative import providers (untuk file dalam screens/) ---
    "import '../../providers/settings_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart';",
    "import '../../providers/onboarding_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/onboarding/providers/onboarding_provider.dart';",
    "import '../providers/settings_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart';",
    "import '../providers/onboarding_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/onboarding/providers/onboarding_provider.dart';",
    "import '../../../providers/settings_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart';",
    "import '../../../providers/onboarding_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/onboarding/providers/onboarding_provider.dart';",

    // --- Model legacy (lib/models/) yang dipindahkan ke shared/models ---
    "import 'package:pendaki_local_guide_app/models/user_model.dart';":
        "import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';",
    "import 'package:pendaki_local_guide_app/models/language_model.dart';":
        "// [MIGRATED] language_model dipindahkan ke features/settings/",
    "import 'package:pendaki_local_guide_app/models/onboarding_model.dart';":
        "// [MIGRATED] onboarding_model dipindahkan ke features/onboarding/",
    "import 'package:pendaki_local_guide_app/models/tracking_model.dart';":
        "// [MIGRATED] tracking_model — akan diintegrasikan dengan shared/models/transactions/",

    // --- Relative imports untuk models ---
    "import '../../models/user_model.dart';":
        "import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';",
    "import '../models/user_model.dart';":
        "import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';",

    // --- Services relative imports ---
    "import '../../services/storage_services.dart';":
        "import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';",
    "import '../services/storage_services.dart';":
        "import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';",
    "import '../../services/auth_service.dart';":
        "import 'package:pendaki_local_guide_app/core/network/auth_service.dart';",
    "import '../services/auth_service.dart';":
        "import 'package:pendaki_local_guide_app/core/network/auth_service.dart';",

    // --- Relative imports dari main.dart sudah pakai absolute, tapi jaga-jaga ---
    "import 'services/storage_services.dart';":
        "import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';",
    "import 'services/auth_service.dart';":
        "import 'package:pendaki_local_guide_app/core/network/auth_service.dart';",
    "import 'providers/settings_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart';",
    "import 'providers/onboarding_provider.dart';":
        "import 'package:pendaki_local_guide_app/features/onboarding/providers/onboarding_provider.dart';",
  };

  // Rekursif ambil semua file .dart di dalam lib/
  final dartFiles = projectRoot
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in dartFiles) {
    fileCount++;
    var content = file.readAsStringSync();
    var originalContent = content;
    int localFixes = 0;

    for (final entry in replacements.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        localFixes++;
      }
    }

    if (content != originalContent) {
      file.writeAsStringSync(content);
      fixCount++;
      print('✅ Fixed ($localFixes replacements): ${file.path}');
    }
  }

  print('\n════════════════════════════════');
  print('📊 Summary:');
  print('   Files scanned : $fileCount');
  print('   Files modified: $fixCount');
  print('════════════════════════════════');
  print('✅ Import fix selesai!');
}
