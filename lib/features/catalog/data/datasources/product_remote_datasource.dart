import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  @override
  Future<List<ProductModel>> getProducts() async {
    // TODO: Implement Laravel API Endpoint /api/products
    return [];
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    // TODO: Implement Laravel API Endpoint /api/products/{id}
    throw UnimplementedError();
  }
}
