part of 'networking_bloc.dart';

@immutable
abstract class NetworkingState {}

class NetworkingInitial extends NetworkingState {}

class NetworkingRequestInProgress extends NetworkingState {}

class NetworkingRequestSuccess extends NetworkingState {
  final Uint8List body;

  final String? bodyDecoded;

  final int status;

  final Map<String, String> headers;

  final bool isImage;

  NetworkingRequestSuccess({
    required this.body,
    required this.headers,
    required this.status,
    required this.isImage,
    this.bodyDecoded,
  });
}

class NetworkingRequestFailure extends NetworkingState {
  final String reason;

  final StackTrace stackTrace;

  NetworkingRequestFailure({
    required this.reason,
    required this.stackTrace,
  });
}
