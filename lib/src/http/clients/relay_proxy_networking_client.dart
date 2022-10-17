import 'package:http/src/client.dart';
import 'package:meta/meta.dart';
import 'package:networking/networking.dart';

@visibleForTesting
const kRelayDestinationServerUrlHeader = 'X-RELAY-URL';
@visibleForTesting
const kAlwaysIncludeBodyHeader = 'X-INCLUDE-BODY';
@visibleForTesting
const kBypassHeadersExposeHeader = 'X-BYPASS-EXPOSE-HEADERS';

const _kDefaultValueForBypassHeaders = 'true';

class RelayProxyNetworkingClient extends ProxyNetworkingClient {
  RelayProxyNetworkingClient({
    required NetworkingClient client,
    required Uri uri,
    final Duration duration = kDefaultTimeoutDuration,
    final List<Interceptor> interceptors = kDefaultInterceptors,
    final bool bypassBodyDelete = false,
    final bool bypassExposeHeaders = false,
  }) : super.custom(
          duration: duration,
          interceptors: interceptors,
          client: client,
          proxyConfiguration: RelayProxyConfiguration(
            client: client.httpClient,
            proxyUri: uri,
            destinationUri: client.baseUrl,
            bypassBodyDelete: bypassBodyDelete,
            bypassExposeHeaders: bypassExposeHeaders,
          ),
        );
}

class RelayProxyConfiguration extends ProxyConfiguration {
  final bool bypassBodyDelete;

  final bool bypassExposeHeaders;

  RelayProxyConfiguration({
    required Client client,
    required Uri proxyUri,
    required Uri destinationUri,
    this.bypassBodyDelete = false,
    this.bypassExposeHeaders = false,
  }) : super.api(
          client: client,
          uri: destinationUri,
          onSend: ({required request}) {
            return request.copyWith(
              uri: proxyUri,
              headers: {
                ...request.headers,
                kRelayDestinationServerUrlHeader: request.uri.toString(),
                if (bypassBodyDelete)
                  kAlwaysIncludeBodyHeader: _kDefaultValueForBypassHeaders,
                if (bypassExposeHeaders)
                  kBypassHeadersExposeHeader: _kDefaultValueForBypassHeaders,
              },
            );
          },
        );
}
