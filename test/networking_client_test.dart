import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networking/networking.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  setUpAll(
    () {
      registerFallbackValue(FakeBaseRequest());
      registerFallbackValue(FakeResponse());
    },
  );

  group(
    'networking client',
    () {
      group(
        'send',
        () {
          group(
            'success responses',
            () {
              test(
                'if status is less than 400 and content type is ContentType.jpeg, JpegImageResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) =>
                        Future.value(fakeStreamedResponseWithJpegContentType),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<JpegImageResponse>(),
                  );
                },
              );

              test(
                'if status is less than 400 and content type is ContentType.json, JsonResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) =>
                        Future.value(fakeStreamedResponseWithJsonContentType),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<JsonResponse>(),
                  );
                },
              );

              test(
                'if status is less than 400 and content type is ContentType.png, PngImageResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(fakeStreamedResponseWithPngContentType),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<PngImageResponse>(),
                  );
                },
              );

              test(
                'if status is less than 400 and content type is ContentType.plainText, PlainTextResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithPlainTextContentType,
                    ),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<PlainTextResponse>(),
                  );
                },
              );

              test(
                'if status is less than 400 and content type is not recognized or binary, BinaryResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseWithBinaryContentType,
                    ),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<BinaryResponse>(),
                  );
                },
              );
            },
          );

          group(
            'failure responses',
            () {
              test(
                'if status is not less than 400, ErrorResponse is returned on the right hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.value(
                      fakeStreamedResponseThatOriginatedFromBadRequest,
                    ),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final rightHand = response.fold((l) => l, (r) => r);

                  expect(
                    rightHand,
                    isA<ErrorResponse>(),
                  );
                },
              );
            },
          );

          group(
            'request errors',
            () {
              test(
                'if TimeOutException is thrown on request send, TimeoutError is returned on the left hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.error(fakeTimeoutException),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final leftHand = response.fold((l) => l, (r) => r);

                  expect(
                    leftHand,
                    isA<TimeoutError>(),
                  );
                },
              );

              test(
                'if SocketException is thrown on request send, NoInternetConnectionError is returned on the left hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.error(fakeSocketException),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final leftHand = response.fold((l) => l, (r) => r);

                  expect(
                    leftHand,
                    isA<NoInternetConnectionError>(),
                  );
                },
              );

              test(
                'if any other exception is thrown on request send, UnknownError is returned on the left hand',
                () async {
                  final mockHttpClient = MockHttpClient();

                  final networkingClient = NetworkingClient(
                    baseUrl: fakeBaseUri,
                    httpClient: mockHttpClient,
                  );

                  when(() => mockHttpClient.send(any()).timeout(any()))
                      .thenAnswer(
                    (_) => Future.error(fakeException),
                  );

                  final response = await networkingClient.send(
                    request: fakeGetRequest,
                  );

                  final leftHand = response.fold((l) => l, (r) => r);

                  expect(
                    leftHand,
                    isA<UnknownError>(),
                  );
                },
              );
            },
          );

          group(
            'interceptors',
            () {
              group(
                'request',
                () {
                  test(
                    'merges interceptor requests before sending the request',
                    () async {
                      final mockHttpClient = MockHttpClient();

                      final mockInterceptor = MockInterceptor();

                      final mockRequest = MockRequest();

                      final mockResponse = MockResponse();

                      final request = fakeGetRequest;

                      final networkingClient = NetworkingClient(
                        baseUrl: fakeBaseUri,
                        httpClient: mockHttpClient,
                        interceptors: [mockInterceptor],
                      );

                      when(
                        () => mockInterceptor.onRequest(request),
                      ).thenReturn(mockRequest);

                      when(
                        () => mockInterceptor.onResponse(any()),
                      ).thenReturn(mockResponse);

                      when(() => mockHttpClient.send(any()).timeout(any()))
                          .thenAnswer(
                        (_) => Future.value(
                          fakeCallableStreamedResponse(),
                        ),
                      );

                      final fakeHeaders = {
                        'hello': 'world',
                      };

                      when(
                        () => mockRequest.headers,
                      ).thenReturn(fakeHeaders);

                      final mergedRequest = request.merge(
                        requests: [mockRequest],
                      );

                      final mergedBaseRequest = mergedRequest.toBaseRequest();

                      await networkingClient.send(request: request);

                      verify(
                        () => mockHttpClient.send(
                          any(
                            that: isA<BaseRequest>().having(
                              (br) => br.headers,
                              'should be the same as merged base request headers',
                              mergedBaseRequest.headers,
                            ),
                          ),
                        ),
                      ).called(1);
                    },
                  );
                },
              );
            },
          );
        },
      );

      group(
        'resolveUri',
        () {
          test(
            'on empty endpoint string provided, returns the same base url',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = '';

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
              );

              final expectedEndpointUri = fakeBaseUri;

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on empty endpoint string provided but with query parameters, returns the same base url + query parameters',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = '';

              final queryParameters = {
                'x': '2',
              };

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
                queryParameters: queryParameters,
              );

              final expectedEndpointUri = Uri.parse(
                '${fakeBaseUri.toString()}?x=2',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided, returns the same base url + /endpoint',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = 'abc';

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
              );

              final expectedEndpointUri = Uri.parse(
                '${fakeBaseUri.toString()}$endpoint',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided but with query parameters, returns the same base url + /endpoint + query parameters',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = 'abc';

              final queryParameters = {
                'x': '2',
              };

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
                queryParameters: queryParameters,
              );

              final expectedEndpointUri = Uri.parse(
                '${fakeBaseUri.toString()}$endpoint?x=2',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided, returns the same base url + /endpoint, even if base url has no resource specified',
            () {
              final baseUrl = fakeBaseUriWithNoResource;

              final endpoint = '/abc';

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
              );

              final expectedEndpointUri = Uri.parse(
                '${baseUrl.toString()}${endpoint.replaceAll('/', '')}',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided but with query parameters, returns the same base url + /endpoint, even if base url has no resource specified',
            () {
              final baseUrl = fakeBaseUriWithNoResource;

              final endpoint = '/abc';

              final queryParameters = {
                'x': '2',
              };

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
                queryParameters: queryParameters,
              );

              final expectedEndpointUri = Uri.parse(
                '${baseUrl.toString()}${endpoint.replaceAll('/', '')}?x=2',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided with multiple resources, returns the same base url + /endpoint',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = 'abc/def/123/';

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
              );

              final expectedEndpointUri = Uri.parse(
                '${fakeBaseUri.toString()}$endpoint',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );

          test(
            'on endpoint string provided with multiple resources but with query parameters, returns the same base url + /endpoint + query parameters',
            () {
              final baseUrl = fakeBaseUri;

              final endpoint = 'abc/def/123';

              final queryParameters = {
                'x': '2',
              };

              final finalEndpointUri = resolveUri(
                baseUrl: baseUrl,
                endpoint: endpoint,
                queryParameters: queryParameters,
              );

              final expectedEndpointUri = Uri.parse(
                '${fakeBaseUri.toString()}$endpoint?x=2',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );
        },
      );
    },
  );
}
