import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' show Client;
import 'package:networking/networking.dart';

part 'networking_event.dart';
part 'networking_state.dart';

class NetworkingBloc extends Bloc<NetworkingEvent, NetworkingState> {
  final NetworkingClient defaultNetworkingClient = NetworkingClient(
    baseUrl: Uri.base,
    httpClient: Client(),
  );

  NetworkingBloc() : super(NetworkingInitial()) {
    on<RequestEvent>(
      (event, emit) async {
        emit(
          NetworkingRequestInProgress(),
        );

        final request = Request(
          uri: Uri.parse(event.url),
          verb: event.verb,
          contentType: event.contentType,
          data: event.payload,
          headers: event.headers,
        );

        var networkingClient = defaultNetworkingClient;

        if (event is RelayProxyRequestEvent) {
          networkingClient = RelayProxyNetworkingClient(
            client: networkingClient,
            uri: Uri.parse(event.relayProxyUrl),
          );
        }

        final result = await networkingClient.send(request: request);

        emit(
          result.fold(
            (l) => NetworkingRequestFailure(
              reason: l.cause,
              stackTrace: l.stackTrace,
            ),
            (r) => NetworkingRequestSuccess(
              body: r.body,
              headers: r.headers,
              status: r.statusCode,
              bodyDecoded: (r is! BinaryResponse || r is! ImageResponse)
                  ? const Utf8Decoder().convert(r.body)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
