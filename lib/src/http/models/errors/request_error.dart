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
