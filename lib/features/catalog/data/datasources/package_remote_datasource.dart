import 'package:pendaki_local_guide_app/shared/models/catalog/package_model.dart';
import 'package:decimal/decimal.dart';

abstract class PackageRemoteDatasource {
  Future<List<PackageModel>> getPackages();
  Future<PackageModel> getPackageById(String id);
}

class PackageRemoteDatasourceImpl implements PackageRemoteDatasource {
  @override
  Future<List<PackageModel>> getPackages() async {
    // TODO: Implement Laravel API Endpoint GET /api/packages
    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 1));
    return [
      PackageModel(
        id: 'pkg1',
        storeId: 'store1',
        name: 'Paket Pemula Hemat',
        description: 'Paket lengkap untuk pendaki pemula 2 hari 1 malam.',
        imageUrl: 'https://images.unsplash.com/photo-1534889156217-d643df14f14a?q=80&w=400',
        price: Decimal.parse('150000'),
        stock: 5,
        items: const [
          PackageItemModel(productId: '1', quantity: 1), // Tenda
          PackageItemModel(productId: '2', quantity: 2), // Sleeping Bag
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PackageModel(
        id: 'pkg2',
        storeId: 'store1',
        name: 'Paket VIP Ekspedisi',
        description: 'Paket premium dengan tenda 4 musim dan kompor portabel.',
        imageUrl: 'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?q=80&w=400',
        price: Decimal.parse('350000'),
        stock: 2,
        items: const [
          PackageItemModel(productId: '3', quantity: 1), // Tenda 4 musim
          PackageItemModel(productId: '4', quantity: 1), // Kompor
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<PackageModel> getPackageById(String id) async {
    // TODO: Implement Laravel API Endpoint GET /api/packages/{id}
    final packages = await getPackages();
    return packages.firstWhere((p) => p.id == id);
  }
}
