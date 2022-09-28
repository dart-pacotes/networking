import 'package:http/http.dart' as http;
import 'package:networking/networking.dart';

///
/// A general purpose networking client to interact with GitHub Raw API
///
class RawGitHubNetworkingClient extends NetworkingClient {
  RawGitHubNetworkingClient({
    required final NetworkingGitHubRepository repository,
  }) : super(
          baseUrl: Uri.parse(
            'https://raw.githubusercontent.com/${repository.user}/${repository.repoId}/${repository.branch}',
          ),
          httpClient: http.Client(),
        );

  RawGitHubNetworkingClient.custom({
    required final Duration duration,
    required final List<Interceptor> interceptors,
    required final NetworkingGitHubRepository repository,
  }) : super(
          baseUrl: Uri.parse(
            'https://raw.githubusercontent.com/${repository.user}/${repository.repoId}/${repository.branch}',
          ),
          httpClient: http.Client(),
          timeoutDuration: duration,
        );
}

///
/// Describes some details of a GitHub repository, needed for creating
/// instances of [RawGitHubNetworkingClient].
///
class NetworkingGitHubRepository {
  final String user;

  final String repoId;

  final String branch;

  const NetworkingGitHubRepository({
    required final this.branch,
    required final this.repoId,
    required final this.user,
  });
}
