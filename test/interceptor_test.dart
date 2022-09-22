import 'package:networking/networking.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group(
    'interceptor',
    () {
      group(
        'authorization',
        () {
          test(
            'creates a copy of the request with the provided authorization header set',
            () {
              final header = 'Authorization';

              final scheme = 'Bearer';

              final parameters = 'token';

              final expectedEntry = MapEntry(header, '$scheme $parameters');

              final interceptor = AuthorizationInterceptor(
                header: header,
                parameters: parameters,
                scheme: scheme,
              );

              final interceptedRequest = interceptor.onRequest(fakeGetRequest);

              final containsExpectedEntry =
                  interceptedRequest.headers.containsEntry(
                expectedEntry,
              );

              expect(containsExpectedEntry, isTrue);
            },
          );
        },
      );
    },
  );
}
