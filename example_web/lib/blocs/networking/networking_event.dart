part of 'networking_bloc.dart';

@immutable
abstract class NetworkingEvent {}

class RequestEvent extends NetworkingEvent {
  final String url;

  final HttpVerb verb;

  final ContentType? contentType;

  final String? payload;

  final Map<String, String> headers;

  RequestEvent({
    required this.headers,
    required this.url,
    required this.verb,
    this.payload,
    this.contentType,
  });
}

class RelayProxyRequestEvent extends RequestEvent {
  final String relayProxyUrl;

  final bool includeAlwaysIncludeBodyHeader;

  final bool includeBypassExposeHeadersHeader;

  RelayProxyRequestEvent({
    required super.headers,
    required super.url,
    required super.verb,
    required this.relayProxyUrl,
    required this.includeAlwaysIncludeBodyHeader,
    required this.includeBypassExposeHeadersHeader,
    super.payload,
    super.contentType,
  });
}
