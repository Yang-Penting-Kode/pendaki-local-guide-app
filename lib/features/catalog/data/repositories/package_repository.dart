import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/package_model.dart';
import 'package:pendaki_local_guide_app/features/catalog/data/datasources/package_remote_datasource.dart';

final packageRemoteDatasourceProvider = Provider<PackageRemoteDatasource>((ref) {
  return PackageRemoteDatasourceImpl();
});

final packageRepositoryProvider = Provider<PackageRepository>((ref) {
  final remote = ref.read(packageRemoteDatasourceProvider);
  return PackageRepository(remoteDatasource: remote);
});

class PackageRepository {
  final PackageRemoteDatasource _remoteDatasource;

  PackageRepository({required PackageRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<PackageModel>> getPackages() async {
    return _remoteDatasource.getPackages();
  }

  Future<PackageModel> getPackageById(String id) async {
    return _remoteDatasource.getPackageById(id);
  }
}
