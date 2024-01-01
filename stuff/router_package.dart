import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'Routing using GoRouter ',
      );

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const Page1Screen(),
        routes: <GoRoute>[
          GoRoute(
            path: 'page2',
            builder: (context, state) => const Page2Screen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(state: state),
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.state});
  final GoRouterState state;

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(state.error.toString()));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GoRouterState>('state', state));
  }
}

class Page1Screen extends StatelessWidget {
  const Page1Screen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => context.go('/page2'),
                child: const Text('Go to page 2'),
              ),
            ],
          ),
        ),
      );
}

class Page2Screen extends StatelessWidget {
  const Page2Screen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Second Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go back to home page'),
              ),
            ],
          ),
        ),
      );
}
