import 'package:dartz/dartz.dart';
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
    required final this.clientId,
  }) : super(
          baseUrl: Uri.parse('https://api.imgur.com/$apiVersion'),
          httpClient: http.Client(),
        );

  ImgurNetworkingClient.withDuration({
    required final Duration duration,
    required final String apiVersion,
    required final this.clientId,
  }) : super(
          baseUrl: Uri.parse('https://api.imgur.com/$apiVersion'),
          httpClient: http.Client(),
          timeoutDuration: duration,
        );

  ImgurNetworkingClient.v3({
    required final String clientId,
  }) : this(apiVersion: '3', clientId: clientId);

  @override
  Future<Either<RequestError, Response>> send({
    required final Request request,
  }) {
    return super.send(
      request: request.copyWith(
        headers: request.headers
          ..addAll(
            {
              'Authorization': 'Client-ID $clientId',
            },
          ),
      ),
    );
  }
}
