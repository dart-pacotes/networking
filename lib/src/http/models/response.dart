import 'dart:convert';
import 'dart:typed_data';

import 'package:networking/src/http/models/errors/http_error.dart';

import 'content_type.dart';

const _kResponseByContentType = {
  ContentType.jpeg: JpegImageResponse.new,
  ContentType.png: PngImageResponse.new,
  ContentType.plainText: PlainTextResponse.new,
  ContentType.json: JsonResponse.new,
};

///
/// Defines an abstract view of an HTTP response
///
abstract class Response {
  final Uint8List body;

  final ContentType contentType;

  final int statusCode;

  final Map<String, String> headers;

  final bool _fullStringify;

  static Response fromContentType({
    required final ContentType contentType,
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) {
    final responseConstructor =
        _kResponseByContentType[contentType] ?? BinaryResponse.new;

    return responseConstructor.call(
      body: body,
      statusCode: statusCode,
      headers: headers,
    );
  }

  const Response({
    required this.body,
    required this.contentType,
    required this.statusCode,
    required this.headers,
    required final bool fullStringify,
  }) : _fullStringify = fullStringify;

  @override
  String toString() =>
      '$runtimeType(Headers: $headers | Body: ${_fullStringify ? utf8.decode(body) : '...'} | Status Code: $statusCode)';
}

///
/// Mixin that interops in responses that can unmarsh the response body
/// as JSON objects and arrays
///
mixin Jsonable on Response {
  Map<String, dynamic> get json =>
      jsonDecode(const Utf8Decoder().convert(body)) ?? {};

  List<dynamic> get asJsonArray =>
      (jsonDecode(
        const Utf8Decoder().convert(
          body,
        ),
      ) as List?) ??
      [];

  List<T> typedAsJsonArray<T>() => List.castFrom(asJsonArray);
}

///
/// Types a response as successful (typical status code range: 200-299)
///
abstract class SuccessResponse extends Response {
  const SuccessResponse({
    required final Uint8List body,
    required final ContentType contentType,
    required final int statusCode,
    required final Map<String, String> headers,
    final bool fullStringify = true,
  }) : super(
          body: body,
          contentType: contentType,
          statusCode: statusCode,
          headers: headers,
          fullStringify: fullStringify,
        );
}

///
/// Types a response as failure (typical status code range: 400-599)
///
class ErrorResponse extends Response with Jsonable {
  const ErrorResponse({
    required final Uint8List body,
    required final ContentType contentType,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: contentType,
          statusCode: statusCode,
          headers: headers,
          fullStringify: true,
        );

  HttpError get toHttpError => HttpError.fromStatusCode(
        statusCode: statusCode,
        cause: utf8.decode(body),
        stackTrace: StackTrace.current,
      );
}

///
/// Types a response as successful and that has the JSON content-type
///
class JsonResponse extends SuccessResponse with Jsonable {
  const JsonResponse({
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.json,
          statusCode: statusCode,
          headers: headers,
        );
}

///
/// Types a response as successful and that has the binary content-type
///
class BinaryResponse extends SuccessResponse {
  const BinaryResponse({
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.binary,
          statusCode: statusCode,
          headers: headers,
        );
}

///
/// Types a response as successful and a general purpose image (with PNG content type)
///
abstract class ImageResponse extends SuccessResponse {
  const ImageResponse({
    required final Uint8List body,
    required final ContentType contentType,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.png,
          statusCode: statusCode,
          headers: headers,
          fullStringify: false,
        );
}

///
/// Types a response as successful and that has the JPEG content-type
///
class JpegImageResponse extends ImageResponse {
  const JpegImageResponse({
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.jpeg,
          statusCode: statusCode,
          headers: headers,
        );
}

///
/// Types a response as successful and that has the PNG content-type
///
class PngImageResponse extends ImageResponse {
  const PngImageResponse({
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.png,
          statusCode: statusCode,
          headers: headers,
        );
}

///
/// Types a response as successful and that has the plain/text content-type
///
class PlainTextResponse extends SuccessResponse with Jsonable {
  const PlainTextResponse({
    required final Uint8List body,
    required final int statusCode,
    required final Map<String, String> headers,
  }) : super(
          body: body,
          contentType: ContentType.plainText,
          statusCode: statusCode,
          headers: headers,
        );

  @override
  String toString() {
    return const Utf8Decoder().convert(body);
  }
}
