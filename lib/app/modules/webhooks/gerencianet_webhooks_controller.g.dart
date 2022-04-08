// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerencianet_webhooks_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$GerencianetWebhooksControllerRouter(
    GerencianetWebhooksController service) {
  final router = Router();
  router.add('POST', r'/webhook/register', service.register);
  router.add('POST', r'/webhook', service.webhookConfig);
  router.add('POST', r'/webhook/pix', service.webhookPaymentCallback);
  return router;
}
