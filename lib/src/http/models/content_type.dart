enum ContentType {
  binary,
  jpeg,
  json,
  png,
  plainText,
}

extension ContentTypeExtension on ContentType {
  String value() {
    switch (this) {
      case ContentType.binary:
        return 'application/octet-stream';
      case ContentType.jpeg:
        return 'image/jpeg';
      case ContentType.json:
        return 'application/json';
      case ContentType.png:
        return 'image/png';
      case ContentType.plainText:
      default:
        return 'text/plain';
    }
  }

  static ContentType of(final String? value) {
    switch (value) {
      case 'image/jpeg':
        return ContentType.jpeg;
      case 'application/json':
        return ContentType.json;
      case 'image/png':
        return ContentType.png;
      default:
        if ((value ?? '').contains('text/plain')) {
          return ContentType.plainText;
        } else {
          return ContentType.binary;
        }
    }
  }
}
