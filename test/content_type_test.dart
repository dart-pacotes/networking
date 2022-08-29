import 'package:networking/networking.dart';
import 'package:test/test.dart';

void main() {
  group(
    'content type',
    () {
      group(
        'value',
        () {
          test(
            'returns "application/octet-stream" on ContentType.binary',
            () {
              final contentType = ContentType.binary;

              final value = contentType.value;

              final expectedValue = 'application/octet-stream';

              expect(value, expectedValue);
            },
          );

          test(
            'returns "image/jpeg" on ContentType.jpeg',
            () {
              final contentType = ContentType.jpeg;

              final value = contentType.value;

              final expectedValue = 'image/jpeg';

              expect(value, expectedValue);
            },
          );

          test(
            'returns "application/json" on ContentType.json',
            () {
              final contentType = ContentType.json;

              final value = contentType.value;

              final expectedValue = 'application/json';

              expect(value, expectedValue);
            },
          );

          test(
            'returns "image/png" on ContentType.png',
            () {
              final contentType = ContentType.png;

              final value = contentType.value;

              final expectedValue = 'image/png';

              expect(value, expectedValue);
            },
          );

          test(
            'returns "text/plain" on ContentType.plainText',
            () {
              final contentType = ContentType.plainText;

              final value = contentType.value;

              final expectedValue = 'text/plain';

              expect(value, expectedValue);
            },
          );
        },
      );

      group(
        'of',
        () {
          test(
            'returns ContentType.jpeg on "image/jpeg"',
            () {
              final value = 'image/jpeg';

              final contentType = ContentTypeExtension.of(value);

              final expectedContentType = ContentType.jpeg;

              expect(contentType, expectedContentType);
            },
          );

          test(
            'returns ContentType.json on "application/json"',
            () {
              final value = 'application/json';

              final contentType = ContentTypeExtension.of(value);

              final expectedContentType = ContentType.json;

              expect(contentType, expectedContentType);
            },
          );

          test(
            'returns ContentType.json on "application/json;charset=UTF-8"',
            () {
              final value = 'application/json;charset=UTF-8';

              final contentType = ContentTypeExtension.of(value);

              final expectedContentType = ContentType.json;

              expect(contentType, expectedContentType);
            },
          );

          test(
            'returns ContentType.plainText on "text/plain"',
            () {
              final value = 'text/plain';

              final contentType = ContentTypeExtension.of(value);

              final expectedContentType = ContentType.plainText;

              expect(contentType, expectedContentType);
            },
          );

          test(
            'returns ContentType.binary on any value',
            () {
              final value = 'anything';

              final contentType = ContentTypeExtension.of(value);

              final expectedContentType = ContentType.binary;

              expect(contentType, expectedContentType);
            },
          );
        },
      );
    },
  );
}
