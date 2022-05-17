# networking

A general purpose HTTP Client for Dart, that is typed and error free.

## How to use

Using the networking client for consuming GitHub Raw API, it is as simple as:

```dart
final repository = NetworkingGitHubRepository(
    user: 'dart-pacotes',
    repoId: 'networking',
    branch: 'master',
);

// Create networking client that interacts with GitHub Raw API
final networkingClient = RawGitHubNetworkingClient(
repository: repository,
);

final endpoint = 'README.md';

// Get README.md content
final getEndpointResult = await networkingClient.get(endpoint: endpoint);

// Tadaaaam!
print(getEndpointResult);
```

## Features

So far, the package offers an HTTP client that works on top of dart `http` package, providing support for `GET`, `POST`, `PUT`, `DELETE` and `PATCH` methods. There is typing for request errors and responses for most of the general used content-types.

## Missing features

These are some of the features that live in the package backlog:

- **Middleware** for HTTP requests and responses
- **WebSocket** integration

## Side Effects

Powered by Dart null sound + [`dartz`](https://pub.dev/packages/dartz) monads, this package is free of null issues and side effects. This is to prevent the throw of any exception that may not be known and caught by developers, and to make sure that information is consistent by contract.

---

### Bugs and Contributions

Found any bug (including typos) in the package? Do you have any suggestion or feature to include for future releases? Please create an issue via GitHub in order to track each contribution. Also, pull requests are very welcome!