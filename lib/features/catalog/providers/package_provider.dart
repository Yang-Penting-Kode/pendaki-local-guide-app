import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/package_model.dart';
import 'package:pendaki_local_guide_app/features/catalog/data/repositories/package_repository.dart';

final packageProvider = FutureProvider<List<PackageModel>>((ref) async {
  final repository = ref.read(packageRepositoryProvider);
  return repository.getPackages();
});
