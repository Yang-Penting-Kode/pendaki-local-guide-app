import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> createOrder(OrderModel order);
  Future<void> updateOrderStatus(String id, String status);
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  @override
  Future<List<OrderModel>> getOrders() async {
    // TODO: Implement Laravel API Endpoint /api/orders
    return [];
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    // TODO: Implement Laravel API Endpoint /api/orders/{id}
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    // TODO: Implement Laravel API Endpoint POST /api/orders
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrderStatus(String id, String status) async {
    // TODO: Implement Laravel API Endpoint PUT /api/orders/{id}/status
    throw UnimplementedError();
  }
}
