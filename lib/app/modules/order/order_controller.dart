import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burger_api/app/service/order_service.dart';
import 'package:vakinha_burger_api/app/view_models/order_view_model.dart';

part 'order_controller.g.dart';

class OrderController {
  final _orderService = OrderService();

  @Route.post('/')
  Future<Response> register(Request request) async {
    final orderVM = OrderViewModel.fromJson(await request.readAsString());
    final order = await _orderService.createOrder(orderVM);
    return Response.ok(
      order.toJson(),
      headers: {
        'content-type': 'application/json',
      },
    );
  }

  Router get router => _$OrderControllerRouter(this);
}
