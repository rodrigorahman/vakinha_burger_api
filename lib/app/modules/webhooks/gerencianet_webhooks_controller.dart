import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burger_api/app/modules/webhooks/view_models/gerencianet_callback_view_model.dart';
import 'package:vakinha_burger_api/app/service/order_service.dart';

part 'gerencianet_webhooks_controller.g.dart';

class GerencianetWebhooksController {
  final _orderService = OrderService();

  @Route.post('/')
  Future<Response> webhookConfig(Request request) async {
    return Response(200, headers: {
      'content-type': 'application/json',
    });
  }

  @Route.post('/pix')
  Future<Response> webhookPaymentCallback(Request request) async {
    try {
      final callback =
          GerencianetCallbackViewModel.fromJson(await request.readAsString());
      await _orderService
          .confirmPayment(callback.pix.map((p) => p.transactionId));

      return Response.ok(jsonEncode({}), headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$GerencianetWebhooksControllerRouter(this);
}
