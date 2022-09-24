import 'package:http/src/client.dart';
import 'package:networking/networking.dart';

class ProxyNetworkingClient extends NetworkingClient {
  const ProxyNetworkingClient({
    required Uri baseUrl,
    required Client httpClient,
  }) : super(
          baseUrl: baseUrl,
          httpClient: httpClient,
        );
}

class ProxyConfiguration {
  final Uri uri;

  final 
}
