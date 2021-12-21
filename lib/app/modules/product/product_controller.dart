import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burger_api/app/repositories/product_repository.dart';

part 'product_controller.g.dart';

class ProductController {
  final _productRepository = ProductRepository();

  @Route.get('/')
  Future<Response> find(Request request) async {
    try {
      final products = await _productRepository.findAll();
      return Response.ok(
          jsonEncode(
            products.map((p) => p.toMap()).toList(),
          ),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      return Response.internalServerError();
    }
  }

  Router get router => _$ProductControllerRouter(this);
}
