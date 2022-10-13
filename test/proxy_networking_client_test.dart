import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networking/networking.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  setUpAll(
    () {
      registerFallbackValue(FakeBaseRequest());
    },
  );

  group(
    'proxy networking client',
    () {
      group(
        'send',
        () {
          group(
            'on api level',
            () {
              test(
                'uses proxy url and port instead of base client url and port',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  final mockProxyConfiguration = MockProxyConfiguration();

                  final request = fakeGetRequest;

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  when(() => mockProxyConfiguration.uri).thenReturn(
                    fakeEndpointUri,
                  );

                  when(() => mockProxyConfiguration.client).thenReturn(
                    mockHttpClient,
                  );

                  final proxyNetworkingClient = ProxyNetworkingClient(
                    client: networkingClient,
                    proxyConfiguration: mockProxyConfiguration,
                  );

                  await proxyNetworkingClient.send(
                    request: request,
                  );

                  verify(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.url,
                          'should be the same as proxy uri',
                          mockProxyConfiguration.uri,
                        ),
                      ),
                    ),
                  );
                },
              );

              test(
                'calls onSend callback before triggering the request',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  final mockProxyConfiguration = MockProxyConfiguration();

                  final request = fakeGetRequest;

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  when(() => mockProxyConfiguration.uri).thenReturn(
                    fakeEndpointUri,
                  );

                  when(() => mockProxyConfiguration.client).thenReturn(
                    mockHttpClient,
                  );

                  final fakeHeaderEntry = MapEntry('sample-header', 'value');

                  when(() => mockProxyConfiguration.onSend).thenReturn(
                    (({required request}) {
                      return request.copyWith(
                        headers: {
                          ...request.headers,
                          fakeHeaderEntry.key: fakeHeaderEntry.value,
                        },
                      );
                    }),
                  );

                  final proxyNetworkingClient = ProxyNetworkingClient(
                    client: networkingClient,
                    proxyConfiguration: mockProxyConfiguration,
                  );

                  await proxyNetworkingClient.send(
                    request: request,
                  );

                  verify(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.headers,
                          'should contain fake header',
                          contains(fakeHeaderEntry.key),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
