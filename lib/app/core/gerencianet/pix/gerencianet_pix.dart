import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:vakinha_burger_api/app/core/gerencianet/gerencianet_rest_client.dart';
import 'package:vakinha_burger_api/app/core/gerencianet/pix/models/billing_gerencianet_model.dart';
import 'package:vakinha_burger_api/app/core/gerencianet/pix/models/qr_code_gerencianet_model.dart';

class GerencianetPix {
  Future<BillingGerencianetModel> generateBilling(
      double value, String? cpf, String? name, int orderId) async {
    try {
      final gerencianetRestClient = GerencianetRestClient();

      final billingData = {
        'calendario': {'expiracao': 3600},
        'devedor': {
          'cpf': cpf,
          'nome': name,
        },
        'valor': {'original': value.toStringAsFixed(2)},
        'chave': env['gerencianetChavePix'],
        'solicitacaoPagador': 'pedido de número $orderId no vakinha burger',
        'infoAdicionais': [
          {'nome': 'orderId', 'valor': '$orderId'}
        ]
      };
      print(billingData);
      final billingResponse = await gerencianetRestClient.auth().post(
            '/v2/cob',
            data: billingData,
          );
      final billingResponseData = billingResponse.data;

      return BillingGerencianetModel(
        transactionId: billingResponseData['txid'],
        locationId: billingResponseData['loc']['id'],
      );
    } on DioError catch (e, s) {
      print(e.response);
      print(s);
      rethrow;
    }
  }

  Future<QrCodeGerencianetModel> getQrCode(int locationId) async {
    try {
      final gerencianetPix = GerencianetRestClient();
      final qrResponse =
          await gerencianetPix.auth().get('/v2/loc/$locationId/qrcode');

      final qrCodeResponseData = qrResponse.data;

      return QrCodeGerencianetModel(
        image: qrCodeResponseData['imagemQrcode'],
        code: qrCodeResponseData['qrcode'],
      );
    } on DioError catch (e, s) {
      print(e.response);
      print(s);
      rethrow;
    }
  }

  Future<void> registerWebHook() async {
    final gerencianetRestClient = GerencianetRestClient();
    await gerencianetRestClient.auth().put(
      '/v2/webhook/${env['gerencianetChavePix']}',
      data: {
        "webhookUrl": env['gerencianetUrlWebHook'],
      },
    );
  }
}
