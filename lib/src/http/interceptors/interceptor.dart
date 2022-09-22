import 'package:networking/networking.dart';

abstract class Interceptor {
  Request onRequest(final Request request);

  Response onResponse(final Response response);

  RequestError onError(final RequestError error);
}

abstract class RequestInterceptor implements Interceptor {
  @override
  RequestError onError(RequestError error) => error;

  @override
  Response onResponse(Response response) => response;
}

abstract class ResponseInterceptor implements Interceptor {
  @override
  RequestError onError(RequestError error) => error;

  @override
  Request onRequest(Request request) => request;
}

abstract class ErrorInterceptor implements Interceptor {
  @override
  Request onRequest(Request request) => request;

  @override
  Response onResponse(Response response) => response;
}
