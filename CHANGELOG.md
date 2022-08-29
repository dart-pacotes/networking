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
