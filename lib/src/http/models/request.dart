import 'content_type.dart';

///
/// Mimics the schema of an HTTP request
///
class Request {
  final ContentType contentType;

  final Map<String, String> headers;

  final String data;

  final Uri uri;

  final HttpVerb verb;

  const Request({
    required this.uri,
    required this.verb,
    final Map<String, String>? headers,
    final ContentType? contentType,
    final String? data,
  })  : headers = headers ?? const {},
        contentType = ContentType.binary,
        data = '';

  Request copyWith({
    Map<String, String>? headers,
  }) {
    return Request(
      uri: uri,
      verb: verb,
      contentType: contentType,
      data: data,
      headers: headers ?? this.headers,
    );
  }
}

///
/// Defines every supported HTTP method
///
enum HttpVerb {
  get,
  post,
  put,
  patch,
  delete,
}

///
/// Applies an extension on [HttpVerb] enum, in order to provide a
/// way to get the HTTP verb as string.
///
/// TODO: In Dart 3.0, there is the possibility to declare methods in enums,
/// so this function should be migrated.
///
extension HttpVerbExtension on HttpVerb {
  String get value => toString().split('.').last;
}

abstract class RequestError {
  final String cause;

  final StackTrace stackTrace;

  const RequestError({
    required this.cause,
    required this.stackTrace,
  });
}

class NoInternetConnectionError extends RequestError {
  const NoInternetConnectionError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace);
}

class TimeoutError extends RequestError {
  const TimeoutError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace);
}

class UnknownError extends RequestError {
  const UnknownError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace);
}
