import 'package:networking/networking.dart';

const _kStatusCodeByHttpErrorClass = {
  400: BadRequestHttpError.new,
  401: UnauthorizedHttpError.new,
  402: PaymentRequiredHttpError.new,
  403: ForbiddenHttpError.new,
  404: NotFoundHttpError.new,
  405: MethodNotAllowedHttpError.new,
  406: NotAcceptableHttpError.new,
  407: ProxyAuthenticationRequiredHttpError.new,
  408: RequestTimeoutHttpError.new,
  409: ConflictHttpError.new,
  410: GoneHttpError.new,
  411: LengthRequiredHttpError.new,
  412: PreconditionFailedHttpError.new,
  413: PayloadTooLargeHttpError.new,
  414: UriTooLongHttpError.new,
  415: UnsupportedMediaTypeHttpError.new,
  416: RangeNotSatisfiableHttpError.new,
  417: ExpectationFailedHttpError.new,
  422: UnprocessableEntityHttpError.new,
  423: LockedHttpError.new,
  424: FailedDependencyHttpError.new,
  425: TooEarlyHttpError.new,
  426: UpgradeRequiredHttpError.new,
  428: PreconditionRequiredHttpError.new,
  429: TooManyRequestsHttpError.new,
  431: RequestHeaderFieldsTooLargeHttpError.new,
  451: UnavailableForLegalReasonsHttpError.new,
  500: InternalServerErrorHttpError.new,
  501: NotImplementedHttpError.new,
  502: BadGatewayHttpError.new,
  503: ServiceUnavailableHttpError.new,
  504: GatewayTimeoutHttpError.new,
  505: HttpVersionNotSupportedHttpError.new,
  506: VariantAlsoNegotiatesHttpError.new,
  507: InsufficientStorageHttpError.new,
  508: LoopDetectedHttpError.new,
  510: NotExtendedHttpError.new,
  511: NetworkAuthenticationRequiredHttpError.new,
};

abstract class HttpError extends RequestError {
  final int statusCode;

  static HttpError fromStatusCode({
    required final int statusCode,
    required final String cause,
    required final StackTrace stackTrace,
  }) {
    final httpErrorClass =
        _kStatusCodeByHttpErrorClass[statusCode] ?? UnknownHttpError.new;

    return httpErrorClass.call(
      statusCode: statusCode,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  const HttpError({
    required this.statusCode,
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace);
}

class BadRequestHttpError extends HttpError {
  const BadRequestHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 400);
}

class UnauthorizedHttpError extends HttpError {
  const UnauthorizedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 401);
}

class PaymentRequiredHttpError extends HttpError {
  const PaymentRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 402);
}

class ForbiddenHttpError extends HttpError {
  const ForbiddenHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 403);
}

class NotFoundHttpError extends HttpError {
  const NotFoundHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 404);
}

class MethodNotAllowedHttpError extends HttpError {
  const MethodNotAllowedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 405);
}

class NotAcceptableHttpError extends HttpError {
  const NotAcceptableHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 406);
}

class ProxyAuthenticationRequiredHttpError extends HttpError {
  const ProxyAuthenticationRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 407);
}

class RequestTimeoutHttpError extends HttpError {
  const RequestTimeoutHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 408);
}

class ConflictHttpError extends HttpError {
  const ConflictHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 409);
}

class GoneHttpError extends HttpError {
  const GoneHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 410);
}

class LengthRequiredHttpError extends HttpError {
  const LengthRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 411);
}

class PreconditionFailedHttpError extends HttpError {
  const PreconditionFailedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 412);
}

class PayloadTooLargeHttpError extends HttpError {
  const PayloadTooLargeHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 413);
}

class UriTooLongHttpError extends HttpError {
  const UriTooLongHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 414);
}

class UnsupportedMediaTypeHttpError extends HttpError {
  const UnsupportedMediaTypeHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 415);
}

class RangeNotSatisfiableHttpError extends HttpError {
  const RangeNotSatisfiableHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 416);
}

class ExpectationFailedHttpError extends HttpError {
  const ExpectationFailedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 417);
}

class UnprocessableEntityHttpError extends HttpError {
  const UnprocessableEntityHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 422);
}

class LockedHttpError extends HttpError {
  const LockedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 423);
}

class FailedDependencyHttpError extends HttpError {
  const FailedDependencyHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 424);
}

class TooEarlyHttpError extends HttpError {
  const TooEarlyHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 425);
}

class UpgradeRequiredHttpError extends HttpError {
  const UpgradeRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 426);
}

class PreconditionRequiredHttpError extends HttpError {
  const PreconditionRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 428);
}

class TooManyRequestsHttpError extends HttpError {
  const TooManyRequestsHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 429);
}

class RequestHeaderFieldsTooLargeHttpError extends HttpError {
  const RequestHeaderFieldsTooLargeHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 431);
}

class UnavailableForLegalReasonsHttpError extends HttpError {
  const UnavailableForLegalReasonsHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 451);
}

class InternalServerErrorHttpError extends HttpError {
  const InternalServerErrorHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 500);
}

class NotImplementedHttpError extends HttpError {
  const NotImplementedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 501);
}

class BadGatewayHttpError extends HttpError {
  const BadGatewayHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 502);
}

class ServiceUnavailableHttpError extends HttpError {
  const ServiceUnavailableHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 503);
}

class GatewayTimeoutHttpError extends HttpError {
  const GatewayTimeoutHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 504);
}

class HttpVersionNotSupportedHttpError extends HttpError {
  const HttpVersionNotSupportedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 505);
}

class VariantAlsoNegotiatesHttpError extends HttpError {
  const VariantAlsoNegotiatesHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 506);
}

class InsufficientStorageHttpError extends HttpError {
  const InsufficientStorageHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 507);
}

class LoopDetectedHttpError extends HttpError {
  const LoopDetectedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 508);
}

class NotExtendedHttpError extends HttpError {
  const NotExtendedHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 510);
}

class NetworkAuthenticationRequiredHttpError extends HttpError {
  const NetworkAuthenticationRequiredHttpError({
    required final String cause,
    required final StackTrace stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: 511);
}

class UnknownHttpError extends HttpError {
  const UnknownHttpError({
    required final String cause,
    required final StackTrace stackTrace,
    required final int statusCode,
  }) : super(cause: cause, stackTrace: stackTrace, statusCode: statusCode);
}
