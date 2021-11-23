import 'dart:convert';

import 'package:args/args.dart';
import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:vakinha_burger_api/app/core/gerencianet/gerencianet_rest_client.dart';

class GerencianetAuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _login();

    options.headers.addAll({
      'authorization': 'Bearer $accessToken',
      'content-type': 'application/json'
    });
    
    options.contentType = 'application/json';

    handler.next(options);
  }

  Future<String> _login() async {
    final client = GerencianetRestClient();

    final headers = {
      'authorization': 'Basic ${_getAuthorization()}',
      'content-type': 'application/json'
    };

    final result = await client.post(
      '/oauth/token',
      data: {
        'grant_type': 'client_credentials'
      },
      options: Options(
        headers: headers,
        contentType: 'application/json'
      )
    );

    return result.data['access_token'];
  }

  String _getAuthorization() {
    final clientId =
        env['GERENCIANET_CLIENT_ID'] ?? env['gerencianetClientId'] ?? '';
    final clientSecret = env['GERENCIANET_CLIENT_SECRET'] ??
        env['gerencianetClientSecret'] ??
        '';

    final authBytes = utf8.encode('$clientId:$clientSecret');
    return base64Encode(authBytes);
  }
}
