import 'package:dartz/dartz.dart';
import 'package:networking/networking.dart';

abstract class Interceptor {
  Request onRequest(final Request request);

  Response onResponse(final Response response);

  RequestError onError(final RequestError error);
}
