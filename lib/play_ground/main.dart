import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/animated_container_page.dart';
import 'pages/animated_opacity_page.dart';
import 'pages/tween_animation_builder_page.dart';

enum AnimationExample {
  animatedContainer,
  animatedOpacity,
  tweenAnimationBuilder,
}

extension on AnimationExample {
  String capitalizeFirstCharacter() {
    final name = describeEnum(this);
    return name.replaceRange(0, 1, name.characters.first.toUpperCase());
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Animations Playground')),
          body: const AnimationExamplesList(),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'animatedContainer':
              return MaterialPageRoute(
                  builder: (_) => const AnimatedContainerPage());
            case 'animatedOpacity':
              return MaterialPageRoute(
                  builder: (_) => const AnimatedOpacityPage());
            case 'tweenAnimationBuilder':
              return MaterialPageRoute(
                  builder: (_) => const TweenAnimationBuilderPage());
            default:
              throw UnimplementedError(
                  'Route ${settings.name} not implemented');
          }
        },
      );
}

class AnimationExamplesList extends StatelessWidget {
  const AnimationExamplesList({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          final example = AnimationExample.values[index];
          final routeName = describeEnum(example);
          return ListTile(
            title: Text(example.capitalizeFirstCharacter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(routeName),
          );
        },
        itemCount: AnimationExample.values.length,
      );
}
