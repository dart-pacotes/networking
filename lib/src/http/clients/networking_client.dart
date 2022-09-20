import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:networking/networking.dart';

final _moreThanTwoSlashesRegex = RegExp('\/{2,}');

/// Base networking client for communicating with external HTTP Web APIs.
/// Internally uses Dart [http] client library and requires one instance of it
/// to start the client. This is done to allow mocking of networking requests.
///
/// Strives to be a functional networking client, removing
/// side effects without throwing
/// errors. Instead it encapsulates them in a Failure monad.
///
/// Also requires the injection of the base URL which requests are originated.
///
/// Permits the timeout of a request after a defined duration.
/// The default timeout duration is 5 minutes.
///
class NetworkingClient {
  final Uri baseUrl;

  final http.Client httpClient;

  final Duration timeoutDuration;

  final List<Interceptor> interceptors;

  const NetworkingClient({
    required this.baseUrl,
    required this.httpClient,
    this.timeoutDuration = const Duration(minutes: 5),
    this.interceptors = const [],
  });

  Future<Either<RequestError, Response>> get({
    required final String endpoint,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: Request(
        verb: HttpVerb.get,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        headers: headers,
      ),
    );
  }

  Future<Either<RequestError, Response>> post({
    required final String endpoint,
    final ContentType contentType = ContentType.json,
    final String? data,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: Request(
        verb: HttpVerb.post,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        contentType: contentType,
        data: data,
        headers: headers,
      ),
    );
  }

  Future<Either<RequestError, Response>> put({
    required final String endpoint,
    final ContentType contentType = ContentType.json,
    final String? data,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: Request(
        verb: HttpVerb.put,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        contentType: contentType,
        data: data,
        headers: headers,
      ),
    );
  }

  Future<Either<RequestError, Response>> patch({
    required final String endpoint,
    final ContentType contentType = ContentType.json,
    final String? data,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: Request(
        verb: HttpVerb.patch,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        contentType: contentType,
        data: data,
        headers: headers,
      ),
    );
  }

  Future<Either<RequestError, Response>> delete({
    required final String endpoint,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: Request(
        verb: HttpVerb.delete,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        headers: headers,
      ),
    );
  }

  ///
  /// Crafts and sends a multipart/form-data request.
  ///
  Future<Either<RequestError, Response>> multipart({
    required final String endpoint,
    final Map<String, String>? form,
    final Map<String, Uint8List>? files,
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) {
    return send(
      request: FormDataRequest(
        verb: HttpVerb.post,
        uri: resolveUri(
          baseUrl: baseUrl,
          endpoint: endpoint,
          queryParameters: queryParameters,
        ),
        files: files,
        form: form,
        headers: headers,
      ),
    );
  }

  Future<Either<RequestError, Response>> send({
    required final Request request,
  }) async {
    late Either<RequestError, Response> result;

    try {
      final mergeRequest = request.merge(
        requests: [
          ...interceptors.map(
            (e) => e.onRequest(request),
          ),
        ],
      );

      final baseRequest = mergeRequest.toBaseRequest();

      final httpResponse =
          await httpClient.send(baseRequest).timeout(timeoutDuration);

      final response = await mapHttpResponseAsResponse(httpResponse);

      for (final interceptor in interceptors) {
        interceptor.onResponse(response);
      }

      result = Right(response);
    } on TimeoutException catch (error, stackTrace) {
      result = Left(
        TimeoutError(cause: error.message ?? 'timeout', stackTrace: stackTrace),
      );
    } on SocketException catch (error, stackTrace) {
      result = Left(
        NoInternetConnectionError(cause: error.message, stackTrace: stackTrace),
      );
    } on Exception catch (error, stackTrace) {
      result = Left(
        UnknownError(cause: error.toString(), stackTrace: stackTrace),
      );
    } finally {
      result = result.leftMap(
        (l) {
          for (final interceptor in interceptors) {
            interceptor.onError(l);
          }

          return l;
        },
      );
    }

    return result;
  }
}

@visibleForTesting
Future<Response> mapHttpResponseAsResponse(
  final http.StreamedResponse httpResponse,
) async {
  final statusCode = httpResponse.statusCode;

  final contentType = ContentTypeExtension.of(
    httpResponse.headers['content-type'] ?? '',
  );

  final body = await httpResponse.stream.toBytes();

  final headers = httpResponse.headers;

  if ((statusCode - 200) < 200) {
    switch (contentType) {
      case ContentType.jpeg:
        return JpegImageResponse(
          body: body,
          statusCode: statusCode,
          headers: headers,
        );
      case ContentType.json:
        return JsonResponse(
          body: body,
          statusCode: statusCode,
          headers: headers,
        );
      case ContentType.png:
        return PngImageResponse(
          body: body,
          statusCode: statusCode,
          headers: headers,
        );
      case ContentType.plainText:
        return PlainTextResponse(
          body: body,
          statusCode: statusCode,
          headers: headers,
        );
      default:
        return BinaryResponse(
          body: body,
          statusCode: statusCode,
          headers: headers,
        );
    }
  } else {
    return ErrorResponse(
      contentType: contentType,
      body: body,
      statusCode: statusCode,
      headers: headers,
    );
  }
}

@visibleForTesting
Uri resolveUri({
  required final Uri baseUrl,
  required final String endpoint,
  final Map<String, String>? queryParameters,
}) {
  final escapedPath =
      '${baseUrl.path}${endpoint.isNotEmpty ? '/$endpoint' : ''}'
          .replaceAll(_moreThanTwoSlashesRegex, '/');

  return baseUrl.resolveUri(
    Uri(
      path: escapedPath,
      queryParameters: queryParameters,
    ),
  );
}
