import 'package:networking/networking.dart';

const _kDefaultAuthorizationHeader = 'Authorization';
const _kBearerScheme = 'Bearer';

class AuthorizationInterceptor extends RequestInterceptor {
  final String header;

  final String scheme;

  final String parameters;

  AuthorizationInterceptor({
    this.header = _kDefaultAuthorizationHeader,
    required this.parameters,
    required this.scheme,
  });

  AuthorizationInterceptor.bearer({
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
}
