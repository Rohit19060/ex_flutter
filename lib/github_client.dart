import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GitHub Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'GitHub Client'),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => GithubLoginWidget(
        builder: (context, httpClient) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: GitHubSummary(
            gitHub: _getGitHub(httpClient.credentials.accessToken),
          ),
        ),
        githubClientId: dotenv.env['githubClientId'].toString(),
        githubClientSecret: dotenv.env['githubClientSecret'].toString(),
        githubScopes: const ['repo', 'read:org'],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

GitHub _getGitHub(String accessToken) =>
    GitHub(auth: Authentication.withToken(accessToken));

final _authorizationEndpoint =
    Uri.parse('https://github.com/login/oauth/authorize');
final _tokenEndpoint = Uri.parse('https://github.com/login/oauth/access_token');

class GithubLoginWidget extends StatefulWidget {
  const GithubLoginWidget({
    required this.builder,
    required this.githubClientId,
    required this.githubClientSecret,
    required this.githubScopes,
    super.key,
  });
  final AuthenticatedBuilder builder;
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  @override
  State<GithubLoginWidget> createState() => _GithubLoginState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('githubScopes', githubScopes));
    properties.add(StringProperty('githubClientSecret', githubClientSecret));
    properties.add(StringProperty('githubClientId', githubClientId));
    properties
        .add(ObjectFlagProperty<AuthenticatedBuilder>.has('builder', builder));
  }
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class _GithubLoginState extends State<GithubLoginWidget> {
  HttpServer? _redirectServer;
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    final client = _client;
    if (client != null) {
      return widget.builder(context, client);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _redirectServer?.close();
            // Bind to an ephemeral port on localhost
            _redirectServer = await HttpServer.bind('localhost', 0);
            final authenticatedHttpClient = await _getOAuth2Client(
                Uri.parse('http://localhost:${_redirectServer!.port}/auth'));
            setState(() {
              _client = authenticatedHttpClient;
            });
          },
          child: const Text('Login to Github'),
        ),
      ),
    );
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    if (widget.githubClientId.isEmpty || widget.githubClientSecret.isEmpty) {
      throw const GithubLoginException(
          'githubClientId and githubClientSecret must be not empty. '
          'See `lib/github_oauth_credentials.dart` for more detail.');
    }
    final grant = oauth2.AuthorizationCodeGrant(
      widget.githubClientId,
      _authorizationEndpoint,
      _tokenEndpoint,
      secret: widget.githubClientSecret,
      httpClient: _JsonAcceptingHttpClient(),
    );
    final authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: widget.githubScopes);

    await _redirect(authorizationUrl);
    final responseQueryParameters = await _listen();
    final client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
    } else {
      throw GithubLoginException('Could not launch $authorizationUrl');
    }
  }

  Future<Map<String, String>> _listen() async {
    final request = await _redirectServer!.first;
    final params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

class GithubLoginException implements Exception {
  const GithubLoginException(this.message);
  final String message;
  @override
  String toString() => message;
}

class GitHubSummary extends StatefulWidget {
  const GitHubSummary({required this.gitHub, super.key});
  final GitHub gitHub;

  @override
  State<GitHubSummary> createState() => _GitHubSummaryState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GitHub>('gitHub', gitHub));
  }
}

class _GitHubSummaryState extends State<GitHubSummary> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Octicons.repo),
                label: Text('Repositories'),
              ),
              NavigationRailDestination(
                icon: Icon(Octicons.issue_opened),
                label: Text('Assigned Issues'),
              ),
              NavigationRailDestination(
                icon: Icon(Octicons.git_pull_request),
                label: Text('Pull Requests'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                RepositoriesList(gitHub: widget.gitHub),
                AssignedIssuesList(gitHub: widget.gitHub),
                PullRequestsList(gitHub: widget.gitHub),
              ],
            ),
          ),
        ],
      );
}

class RepositoriesList extends StatefulWidget {
  const RepositoriesList({required this.gitHub, super.key});
  final GitHub gitHub;

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GitHub>('gitHub', gitHub));
  }
}

class _RepositoriesListState extends State<RepositoriesList> {
  @override
  void initState() {
    super.initState();
    _repositories = widget.gitHub.repositories.listRepositories().toList();
  }

  late Future<List<Repository>> _repositories;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Repository>>(
        future: _repositories,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final repositories = snapshot.data;
          return ListView.builder(
            primary: false,
            itemBuilder: (context, index) {
              final repository = repositories![index];
              return ListTile(
                title:
                    Text('${repository.owner?.login ?? ''}/${repository.name}'),
                subtitle: Text(repository.description),
                onTap: () => _launchUrl(context, repository.htmlUrl),
              );
            },
            itemCount: repositories!.length,
          );
        },
      );
}

class AssignedIssuesList extends StatefulWidget {
  const AssignedIssuesList({required this.gitHub, super.key});
  final GitHub gitHub;

  @override
  State<AssignedIssuesList> createState() => _AssignedIssuesListState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GitHub>('gitHub', gitHub));
  }
}

class _AssignedIssuesListState extends State<AssignedIssuesList> {
  @override
  void initState() {
    super.initState();
    _assignedIssues = widget.gitHub.issues.listByUser().toList();
  }

  late Future<List<Issue>> _assignedIssues;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Issue>>(
        future: _assignedIssues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final assignedIssues = snapshot.data;
          return ListView.builder(
            primary: false,
            itemBuilder: (context, index) {
              final assignedIssue = assignedIssues![index];
              return ListTile(
                title: Text(assignedIssue.title),
                subtitle: Text('${_nameWithOwner(assignedIssue)} '
                    'Issue #${assignedIssue.number} '
                    'opened by ${assignedIssue.user?.login ?? ''}'),
                onTap: () => _launchUrl(context, assignedIssue.htmlUrl),
              );
            },
            itemCount: assignedIssues!.length,
          );
        },
      );

  String _nameWithOwner(Issue assignedIssue) {
    final endIndex = assignedIssue.url.lastIndexOf('/issues/');
    return assignedIssue.url.substring(29, endIndex);
  }
}

class PullRequestsList extends StatefulWidget {
  const PullRequestsList({required this.gitHub, super.key});
  final GitHub gitHub;

  @override
  State<PullRequestsList> createState() => _PullRequestsListState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GitHub>('gitHub', gitHub));
  }
}

class _PullRequestsListState extends State<PullRequestsList> {
  @override
  void initState() {
    super.initState();
    _pullRequests = widget.gitHub.pullRequests
        .list(RepositorySlug('flutter', 'flutter'))
        .toList();
  }

  late Future<List<PullRequest>> _pullRequests;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<PullRequest>>(
        future: _pullRequests,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pullRequests = snapshot.data;
          return ListView.builder(
            primary: false,
            itemBuilder: (context, index) {
              final pullRequest = pullRequests![index];
              return ListTile(
                title: Text(pullRequest.title ?? ''),
                subtitle: Text('flutter/flutter '
                    'PR #${pullRequest.number} '
                    'opened by ${pullRequest.user?.login ?? ''} '
                    '(${pullRequest.state?.toLowerCase() ?? ''})'),
                onTap: () => _launchUrl(context, pullRequest.htmlUrl ?? ''),
              );
            },
            itemCount: pullRequests!.length,
          );
        },
      );
}

Future<void> _launchUrl(BuildContext context, String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation error'),
        content: Text('Could not launch $url'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
