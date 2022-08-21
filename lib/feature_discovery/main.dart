import 'package:flutter/material.dart';

import 'feature_discovery.dart';

void main() => runApp(const MyApp());

const feature1 = 'FEATURE_1',
    feature2 = 'FEATURE_2',
    feature3 = 'FEATURE_3',
    feature4 = 'FEATURE_4';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Feature Discovery',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => FeatureDiscovery(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: DescribeFeatureOverlay(
              featureId: feature1,
              icon: Icons.menu,
              color: Colors.red,
              title: 'The Title',
              description: 'The Description',
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            title: const Text(''),
            actions: [
              DescribeFeatureOverlay(
                featureId: feature2,
                icon: Icons.search,
                color: Colors.red,
                title: 'Search in here',
                description: 'The Description',
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: const Content(),
          floatingActionButton: DescribeFeatureOverlay(
            featureId: feature3,
            icon: Icons.add,
            color: Colors.red,
            title: 'Fab in here',
            description: 'The Description',
            child: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {},
            ),
          ),
        ),
      );
}

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/pic.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Starbucks Kyoto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Text(
                      'Coffee Shop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: const Text('Do Feature Discovery :D'),
                  onPressed: () {
                    FeatureDiscovery.discoverFeatures(
                        context, [feature1, feature2, feature3, feature4]);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 200.0,
            right: 0.0,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: DescribeFeatureOverlay(
                featureId: feature4,
                icon: Icons.drive_eta,
                color: Colors.red,
                title: 'Fab in here',
                description: 'The Description',
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  child: const Icon(
                    Icons.drive_eta,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      );
}
