## 0.0.10

- Fix relay proxy not using destination server base url for requests

## 0.0.9

- Include proxy usage as a networking client
- Include relay proxy usage as networking client
- Include bypass headers configuration for relay proxy configuration
- Include web example demo

## 0.0.8

- Fix bad usage of `HttpError` constructor tear-off

## 0.0.7

- Include support of "HTTP Errors" (status code 400-599) as `RequestError`
- Include more content(mime) types
- Increase min Dart SDK version to 2.15 (to include support of constructor tear-off)

## 0.0.6

- Fix bug where responses which content-type header had the charset concatenated (e.g., application/json;charset=UTF-8) were not getting recognized
- Include example code in `lib` and call it from `bin`

## 0.0.5

- Include support for multipart requests (#1)

## 0.0.4

- Include out-of-the-box JSON encoding for `Map` objects (#6)
- Fix bug where `resolveUri` method would output no host if base url or endpoint had multiple slashes (#7)

## 0.0.3

Fix #2

- Fixed `Request` class properties not being correctly assigned

## 0.0.2

Actual first release of networking package.

- Side Effect free HTTP client library (`GET`, `POST`, `PUT`, `DELETE` and `PATCH`)
- Out-of-the-box Networking Client for GitHub Raw API consume
- Out-of-the-box Networking Client for Imgur REST API consume

## 0.0.1

- Initial version (package bootstrap).
