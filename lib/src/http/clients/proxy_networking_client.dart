import 'package:dartz/dartz.dart';
import 'package:http/src/client.dart';
import 'package:networking/networking.dart';

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
    final sendCallback = proxyConfiguration.onSend ?? client.send;

    return sendCallback(request: request);
  }
}

class ProxyConfiguration {
  final Uri uri;

  final Client client;

  final NetworkingSendCallback? onSend;

  const ProxyConfiguration({
    required this.client,
    required this.uri,
    this.onSend,
  });

  const ProxyConfiguration.api({
    required Client client,
    required Uri uri,
    required NetworkingSendCallback onSend,
  }) : this(client: client, uri: uri, onSend: onSend);
}
