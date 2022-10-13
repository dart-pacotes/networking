import 'package:dartz/dartz.dart';
import 'package:http/src/client.dart';
import 'package:networking/networking.dart';

typedef OnProxySendCallback = Request Function({
  required Request request,
});

///
/// A [NetworkingClient] which relays requests to a proxy web server. No initial
/// `CONNECT` request is sent, as this proxy client acts on an API level.
///
class ProxyNetworkingClient extends NetworkingClient {
  final ProxyConfiguration proxyConfiguration;

  final NetworkingClient client;

  ProxyNetworkingClient({
    required this.client,
    required this.proxyConfiguration,
  }) : super(
          baseUrl: proxyConfiguration.uri,
          httpClient: proxyConfiguration.client,
          interceptors: client.interceptors,
          timeoutDuration: client.timeoutDuration,
        );

  ProxyNetworkingClient.custom({
    required final Duration duration,
    required final List<Interceptor> interceptors,
    required this.client,
    required this.proxyConfiguration,
  }) : super(
          baseUrl: proxyConfiguration.uri,
          httpClient: proxyConfiguration.client,
          timeoutDuration: duration,
          interceptors: interceptors,
        );

  @override
  Future<Either<RequestError, Response>> send({
    required final Request request,
  }) {
    final proxyRequest =
        proxyConfiguration.onSend?.call(request: request) ?? request;

    return client.send(request: proxyRequest);
  }
}

class ProxyConfiguration {
  final Uri uri;

  final Client client;

  final OnProxySendCallback? onSend;

  const ProxyConfiguration({
    required this.client,
    required this.uri,
    this.onSend,
  });

  const ProxyConfiguration.api({
    required Client client,
    required Uri uri,
    required OnProxySendCallback onSend,
  }) : this(client: client, uri: uri, onSend: onSend);
}
