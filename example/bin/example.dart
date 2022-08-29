import 'dart:io';

import 'package:networking/networking.dart';

void main() async {
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

  exit(0);
}
