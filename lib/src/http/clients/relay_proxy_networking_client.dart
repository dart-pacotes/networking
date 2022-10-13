import 'package:http/src/client.dart';
import 'package:networking/networking.dart';

const _kRelayDestinationServerUrlHeader = 'X-DESTINATION-URL';

class RelayProxyNetworkingClient extends ProxyNetworkingClient {
  RelayProxyNetworkingClient({
    required Duration duration,
    required List<Interceptor> interceptors,
    required NetworkingClient client,
    required Uri uri,
  }) : super.custom(
          duration: duration,
          interceptors: interceptors,
          client: client,
          proxyConfiguration: RelayProxyConfiguration(
            client: client.httpClient,
            uri: uri,
          ),
        );
}

class RelayProxyConfiguration extends ProxyConfiguration {
  RelayProxyConfiguration({
    required Client client,
    required Uri uri,
  }) : super.api(
          client: client,
          uri: uri,
          onSend: ({required request}) {
            return request.copyWith(
              headers: {
                ...request.headers,
                _kRelayDestinationServerUrlHeader: request.uri.toString(),
              },
            );
          },
        );
}
