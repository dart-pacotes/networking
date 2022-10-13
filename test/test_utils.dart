import 'dart:async';
import 'dart:io';

import 'package:http/http.dart'
    show ByteStream, Client, StreamedResponse, BaseRequest;

import 'package:mocktail/mocktail.dart';
import 'package:networking/networking.dart';

class MockHttpClient extends Mock implements Client {}

class MockStreamedResponse extends Mock implements StreamedResponse {}

class MockRequest extends Mock implements Request {}

class MockResponse extends Mock implements Response {}

class MockInterceptor extends Mock implements Interceptor {}

class MockProxyConfiguration extends Mock implements ProxyConfiguration {}

class FakeBaseRequest extends Fake implements BaseRequest {}

class FakeResponse extends Fake implements Response {}

const fakeEndpoint = 'fake';

final fakeBaseUri = Uri.base;

final fakeEndpointUri = Uri.base.resolve(fakeEndpoint);

final fakeBaseUriWithNoResource = Uri.parse('https://google.com/');

extension MapExtension<K, V> on Map<K, V> {
  bool containsEntry(MapEntry<K, V> entry) {
    return entries
        .where(
          (e) => e.key == entry.key && entry.value == e.value,
        )
        .isNotEmpty;
  }
}

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

final fakeCallableStreamedResponse = () {
  return StreamedResponse(
    fakeByteStream,
    400,
    headers: {'content-type': ContentType.binary.value},
  );
};

final fakeTimeoutException = TimeoutException('timeout');

final fakeSocketException = SocketException('no internet');

final fakeException = Exception('unknown');

final fakeGetRequest = Request(
  uri: fakeEndpointUri,
  verb: HttpVerb.get,
);
