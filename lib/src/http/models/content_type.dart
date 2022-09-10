// TODO: In Dart 2.17 we can use enum constructors, which should remove the need for these maps

const _kContentTypeForValue = {
  ContentType.binary: 'application/octet-stream',
  ContentType.formData: 'multipart/form-data',
  ContentType.jpeg: 'image/jpeg',
  ContentType.json: 'application/json',
  ContentType.png: 'image/png',
  ContentType.avif: 'image/avif',
  ContentType.bmp: 'image/bmp',
  ContentType.gif: 'image/gif',
  ContentType.gzip: 'application/gzip',
  ContentType.ico: 'image/vnd.microsoft.icon',
  ContentType.jsonld: 'application/ld+json',
  ContentType.pdf: 'application/pdf',
  ContentType.svg: 'image/svg+xml',
  ContentType.tiff: 'image/tiff',
  ContentType.webp: 'image/webp',
  ContentType.xhtml: 'application/xhtml+xml',
  ContentType.xml: 'application/xml',
  ContentType.zip: 'application/zip',
  ContentType.js: 'text/javascript',
  ContentType.plainText: 'text/plain',
};

const _kValueForContentType = {
  'application/octet-stream': ContentType.binary,
  'multipart/form-data': ContentType.formData,
  'image/jpeg': ContentType.jpeg,
  'application/json': ContentType.json,
  'image/png': ContentType.png,
  'image/avif': ContentType.avif,
  'image/bmp': ContentType.bmp,
  'image/gif': ContentType.gif,
  'application/gzip': ContentType.gzip,
  'image/vnd.microsoft.icon': ContentType.ico,
  'application/ld+json': ContentType.jsonld,
  'application/pdf': ContentType.pdf,
  'image/svg+xml': ContentType.svg,
  'image/tiff': ContentType.tiff,
  'image/webp': ContentType.webp,
  'application/xhtml+xml': ContentType.xhtml,
  'application/xml': ContentType.xml,
  'application/zip': ContentType.zip,
  'text/javascript': ContentType.js,
  'text/plain': ContentType.plainText,
};

const _kDefaultContentTypeEntry = MapEntry(
  ContentType.binary,
  'application/octet-stream',
);

enum ContentType {
  avif,
  binary,
  bmp,
  formData,
  gif,
  gzip,
  ico,
  jpeg,
  js,
  json,
  jsonld,
  pdf,
  plainText,
  png,
  svg,
  tiff,
  webp,
  xhtml,
  xml,
  zip,
}

extension ContentTypeExtension on ContentType {
  String get value {
    return _kContentTypeForValue[this] ?? _kDefaultContentTypeEntry.value;
  }

  static ContentType of(final String value) {
    final mimeType = value.split(';').first;

    return _kValueForContentType[mimeType] ?? _kDefaultContentTypeEntry.key;
  }
}
