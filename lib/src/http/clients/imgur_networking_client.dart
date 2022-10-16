import 'package:http/http.dart' as http;
import 'package:networking/networking.dart';

///
/// A general purpose networking client to interact with Imgur REST API
///
/// Use `v3` constructor for latest API Version
///
class ImgurNetworkingClient extends NetworkingClient {
  final String clientId;

  ImgurNetworkingClient({
    required final String apiVersion,
    required this.clientId,
  }) : super(
          baseUrl: Uri.parse('https://api.imgur.com/$apiVersion'),
          httpClient: http.Client(),
          interceptors: [
            ImgurApiAuthorizationInterceptor(clientId: clientId),
          ],
        );

  ImgurNetworkingClient.custom({
    required final Duration duration,
    required final List<Interceptor> interceptors,
    required final String apiVersion,
    required this.clientId,
  }) : super(
          baseUrl: Uri.parse('https://api.imgur.com/$apiVersion'),
          httpClient: http.Client(),
          timeoutDuration: duration,
          interceptors: [
            ImgurApiAuthorizationInterceptor(clientId: clientId),
            ...interceptors,
          ],
        );

  ImgurNetworkingClient.v3({
    required final String clientId,
  }) : this(
          apiVersion: '3',
          clientId: clientId,
        );
}

class ImgurApiAuthorizationInterceptor extends AuthorizationInterceptor {
  ImgurApiAuthorizationInterceptor({
    required final String clientId,
  }) : super(parameters: clientId, scheme: 'Client-ID');
}
