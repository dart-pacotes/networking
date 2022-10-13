import 'package:http/src/client.dart';
import 'package:meta/meta.dart';
import 'package:networking/networking.dart';

@visibleForTesting
const kRelayDestinationServerUrlHeader = 'X-RELAY-URL';

class RelayProxyNetworkingClient extends ProxyNetworkingClient {
  RelayProxyNetworkingClient({
    required NetworkingClient client,
    required Uri uri,
    final Duration duration = kDefaultTimeoutDuration,
    final List<Interceptor> interceptors = kDefaultInterceptors,
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
                kRelayDestinationServerUrlHeader: request.uri.toString(),
              },
            );
          },
        );
}
