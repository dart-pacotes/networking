import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'content_type.dart';

const _kFormDataFileField = 'file';

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
        contentType = contentType ?? ContentType.binary,
        data = data ?? '';

  Request copyWith({
    Map<String, String>? headers,
  }) {
    if (this is FormDataRequest) {
      final request = this as FormDataRequest;

      return FormDataRequest(
        uri: uri,
        verb: verb,
        files: request.files,
        form: request.form,
        headers: headers ?? this.headers,
      );
    } else {
      return Request(
        uri: uri,
        verb: verb,
        contentType: contentType,
        data: data,
        headers: headers ?? this.headers,
      );
    }
  }

  http.BaseRequest toBaseRequest() {
    final httpRequest = http.Request(verb.value, uri);

    httpRequest.headers
      ..addAll(headers)
      ..addAll(
        {'Content-Type': contentType.value},
      );

    httpRequest.body = data;

    return httpRequest;
  }
}

///
/// An implementation of [Request] for multipart/form-data requests
///
class FormDataRequest extends Request {
  final Map<String, Uint8List> files;

  final Map<String, String> form;

  const FormDataRequest({
    required Uri uri,
    required HttpVerb verb,
    final Map<String, Uint8List>? files,
    final Map<String, String>? form,
    final Map<String, String>? headers,
  })  : form = form ?? const {},
        files = files ?? const {},
        super(
          uri: uri,
          verb: verb,
          contentType: ContentType.formData,
          headers: headers,
        );

  http.BaseRequest toBaseRequest() {
    final httpRequest = http.MultipartRequest(verb.value, uri);

    httpRequest.headers.addAll(headers);

    httpRequest.fields.addAll(form);

    httpRequest.files.addAll(
      files.entries.map(
        (e) => http.MultipartFile.fromBytes(
          _kFormDataFileField,
          e.value,
          filename: e.key,
        ),
      ),
    );

    return httpRequest;
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
