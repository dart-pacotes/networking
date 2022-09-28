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
    return proxyConfiguration.send?.call(request) ??
        client.send(request: request);
  }
}

class ProxyConfiguration {
  final Uri uri;

  final Client client;

  final Future<Either<RequestError, Response>> Function(Request request)? send;

  const ProxyConfiguration({
    required this.client,
    required this.uri,
    this.send,
  });

  const ProxyConfiguration.api({
    required this.client,
    required this.uri,
    required this.send,
  });
}
