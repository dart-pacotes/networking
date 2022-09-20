import 'package:networking/networking.dart';

const _kDefaultAuthorizationHeader = 'Authorization';
const _kBearerScheme = 'Bearer';

class AuthorizationInterceptor implements Interceptor {
  final String header;

  final String scheme;

  final String parameters;

  const AuthorizationInterceptor({
    required this.header,
    required this.parameters,
    required this.scheme,
  });

  const AuthorizationInterceptor.bearer({
    required final String parameters,
  }) : this(
          header: _kDefaultAuthorizationHeader,
          parameters: parameters,
          scheme: _kBearerScheme,
        );

  @override
  Request onRequest(Request request) {
    return request.copyWith(
      headers: {
        ...request.headers,
        header: '$scheme $parameters',
      },
    );
  }

  @override
  RequestError onError(RequestError error) => error;

  @override
  Response onResponse(Response response) => response;
}
