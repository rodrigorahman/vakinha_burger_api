import 'package:prometheus_client/prometheus_client.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware requestCounter([CollectorRegistry? registry]) {
  final counter = Counter(
    name: 'count_request',
    help: 'Total Requests',
    labelNames: ['path'],
  );

  registry ??= CollectorRegistry.defaultRegistry;
  registry.register(counter);

  return (innerHandler) {
    return (request) {
      final path = request.url.path;
      counter.labels([path]).inc();
      return innerHandler(request);
    };
  };
}

shelf.Middleware requestTimeDurationPerPath([CollectorRegistry? registry]) {
  final histogram = Histogram(
    name: 'http_request_duration_path_seconds',
    help: 'A histogram of the HTTP request durations.',
    labelNames: ['path', 'method', 'code'],
  );

  registry ??= CollectorRegistry.defaultRegistry;
  registry.register(histogram);

  return (innerHandler) {
    return (request) {
      var watch = Stopwatch()..start();

      return Future.sync(() => innerHandler(request)).then((response) {
        histogram.labels([request.url.path, request.method, '${response.statusCode}']).observe(
            watch.elapsedMicroseconds / Duration.microsecondsPerSecond);

        return response;
      }, onError: (error, StackTrace stackTrace) {
        if (error is shelf.HijackException) {
          throw error;
        }

        histogram.labels([request.method, '000']).observe(
            watch.elapsedMicroseconds / Duration.microsecondsPerSecond);

        throw error;
      });
    };
  };
}