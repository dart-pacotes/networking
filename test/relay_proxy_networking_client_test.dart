import 'package:http/http.dart' hide Request;
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
    'relay proxy networking client',
    () {
      group(
        'send',
        () {
          test(
            'uses relay proxy server url on request',
            () async {
              final relayProxyServerUri = fakeRelayProxyServerUri;

              final destinationServerUri = fakeBaseUri;

              final mockHttpClient = MockHttpClient();

              final networkingClient = NetworkingClient(
                baseUrl: destinationServerUri,
                httpClient: mockHttpClient,
              );

              final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                client: networkingClient,
                uri: relayProxyServerUri,
              );

              final request = Request(
                uri: resolveUri(
                  baseUrl: destinationServerUri,
                  endpoint: fakeEndpoint,
                ),
                verb: HttpVerb.get,
              );

              when(() => mockHttpClient.send(any()).timeout(any())).thenAnswer(
                (_) => Future.value(
                  fakeStreamedResponseWithJpegContentType,
                ),
              );

              await relayProxyNetworkingClient.send(
                request: request,
              );

              verify(
                () => mockHttpClient.send(
                  any(
                    that: isA<BaseRequest>().having(
                      (br) => br.url,
                      'should be the same as relay proxy uri',
                      same(
                        relayProxyServerUri,
                      ),
                    ),
                  ),
                ),
              );
            },
          );

          test(
            'attaches destination server url header before triggering the request',
            () async {
              final relayProxyServerUri = fakeRelayProxyServerUri;

              final destinationServerUri = fakeBaseUri;

              final mockHttpClient = MockHttpClient();

              final networkingClient = NetworkingClient(
                baseUrl: destinationServerUri,
                httpClient: mockHttpClient,
              );

              final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                client: networkingClient,
                uri: relayProxyServerUri,
              );

              final request = Request(
                uri: resolveUri(
                  baseUrl: destinationServerUri,
                  endpoint: fakeEndpoint,
                ),
                verb: HttpVerb.get,
              );

              when(() => mockHttpClient.send(any()).timeout(any())).thenAnswer(
                (_) => Future.value(
                  fakeStreamedResponseWithJpegContentType,
                ),
              );

              await relayProxyNetworkingClient.send(
                request: request,
              );

              verify(
                () => mockHttpClient.send(
                  any(
                    that: isA<BaseRequest>().having(
                      (br) => br.headers,
                      'should contain relay destination server url header mapped to server url',
                      containsPair(
                        kRelayDestinationServerUrlHeader,
                        request.uri.toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );

          group(
            'bypass headers',
            () {
              test(
                'does not include always include body header if not specified in proxy configuration',
                () async {
                  final relayProxyServerUri = fakeRelayProxyServerUri;

                  final destinationServerUri = fakeBaseUri;

                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: destinationServerUri,
                    httpClient: mockHttpClient,
                  );

                  final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                    client: networkingClient,
                    uri: relayProxyServerUri,
                  );

                  final request = Request(
                    uri: resolveUri(
                      baseUrl: destinationServerUri,
                      endpoint: fakeEndpoint,
                    ),
                    verb: HttpVerb.get,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  await relayProxyNetworkingClient.send(
                    request: request,
                  );

                  verifyNever(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.headers,
                          'should contain always include body header',
                          contains(
                            kAlwaysIncludeBodyHeader,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              test(
                'does not include bypass expose headers header if not specified in proxy configuration',
                () async {
                  final relayProxyServerUri = fakeRelayProxyServerUri;

                  final destinationServerUri = fakeBaseUri;

                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: destinationServerUri,
                    httpClient: mockHttpClient,
                  );

                  final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                    client: networkingClient,
                    uri: relayProxyServerUri,
                  );

                  final request = Request(
                    uri: resolveUri(
                      baseUrl: destinationServerUri,
                      endpoint: fakeEndpoint,
                    ),
                    verb: HttpVerb.get,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  await relayProxyNetworkingClient.send(
                    request: request,
                  );

                  verifyNever(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.headers,
                          'should contain bypass expose headers header',
                          contains(
                            kBypassHeadersExposeHeader,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              test(
                'includes always include body header if specified in proxy configuration',
                () async {
                  final relayProxyServerUri = fakeRelayProxyServerUri;

                  final destinationServerUri = fakeBaseUri;

                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: destinationServerUri,
                    httpClient: mockHttpClient,
                  );

                  final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                    client: networkingClient,
                    uri: relayProxyServerUri,
                    bypassBodyDelete: true,
                  );

                  final request = Request(
                    uri: resolveUri(
                      baseUrl: destinationServerUri,
                      endpoint: fakeEndpoint,
                    ),
                    verb: HttpVerb.get,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  await relayProxyNetworkingClient.send(
                    request: request,
                  );

                  verify(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.headers,
                          'should contain always include body header',
                          contains(
                            kAlwaysIncludeBodyHeader,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              test(
                'includes bypass expose headers header if specified in proxy configuration',
                () async {
                  final relayProxyServerUri = fakeRelayProxyServerUri;

                  final destinationServerUri = fakeBaseUri;

                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: destinationServerUri,
                    httpClient: mockHttpClient,
                  );

                  final relayProxyNetworkingClient = RelayProxyNetworkingClient(
                    client: networkingClient,
                    uri: relayProxyServerUri,
                    bypassExposeHeaders: true,
                  );

                  final request = Request(
                    uri: resolveUri(
                      baseUrl: destinationServerUri,
                      endpoint: fakeEndpoint,
                    ),
                    verb: HttpVerb.get,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithJpegContentType,
                    ),
                  );

                  await relayProxyNetworkingClient.send(
                    request: request,
                  );

                  verify(
                    () => mockHttpClient.send(
                      any(
                        that: isA<BaseRequest>().having(
                          (br) => br.headers,
                          'should contain bypass expose headers header',
                          contains(
                            kBypassHeadersExposeHeader,
                          ),
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
