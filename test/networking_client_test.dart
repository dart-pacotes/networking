import 'dart:async';
import 'dart:io';

import 'package:http/http.dart'
    show ByteStream, Client, StreamedResponse, BaseRequest;
import 'package:mocktail/mocktail.dart';
import 'package:networking/networking.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements Client {}

class MockStreamedResponse extends Mock implements StreamedResponse {}

class FakeBaseRequest extends Fake implements BaseRequest {}

final fakeBaseUri = Uri.base;

final fakeEndpointUri = Uri.base;

ByteStream get fakeByteStream => ByteStream.fromBytes([]);

final fakeStreamedResponseWithJpegContentType = StreamedResponse(
  fakeByteStream,
  200,
  headers: {'content-type': ContentType.jpeg.value},
);

final fakeStreamedResponseWithJsonContentType = StreamedResponse(
  fakeByteStream,
  200,
  headers: {'content-type': ContentType.json.value},
);

final fakeStreamedResponseWithPngContentType = StreamedResponse(
  fakeByteStream,
  200,
  headers: {'content-type': ContentType.png.value},
);

final fakeStreamedResponseWithPlainTextContentType = StreamedResponse(
  fakeByteStream,
  200,
  headers: {'content-type': ContentType.plainText.value},
);

final fakeStreamedResponseWithBinaryContentType = StreamedResponse(
  fakeByteStream,
  200,
  headers: {'content-type': ContentType.binary.value},
);

final fakeStreamedResponseThatOriginatedFromBadRequest = StreamedResponse(
  fakeByteStream,
  400,
  headers: {'content-type': ContentType.binary.value},
);

final fakeTimeoutException = TimeoutException('timeout');

final fakeSocketException = SocketException('no internet');

final fakeException = Exception('unknown');

final fakeGetRequest = Request(
  uri: fakeEndpointUri,
  verb: HttpVerb.get,
);

void main() {
  setUpAll(
    () {
      registerFallbackValue(FakeBaseRequest());
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
                '${fakeBaseUri.toString()}/$endpoint',
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
                '${fakeBaseUri.toString()}/$endpoint?x=2',
              );

              expect(finalEndpointUri, expectedEndpointUri);
            },
          );
        },
      );
    },
  );
}
