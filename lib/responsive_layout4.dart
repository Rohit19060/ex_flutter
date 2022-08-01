import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextStyle _bodytextstyle =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  var pricebuttonpapdding = MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 50, vertical: 25));
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ListView(
        children: [
          Column(
            children: [
              size.width > 740
                  ? const MyCustomAppbar()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 60),
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Design Buddy',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.menu),
                            )
                          ])),
              const SizedBox(height: 40),
              Text('Unlimited Design', style: _bodytextstyle),
              Text('Subscription Service', style: _bodytextstyle),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.5,
                child: const Text(
                  'A design-made-easy monthly subscription solutionm tailored around your business needs. No fuss, no hassle, no messy contracts, just straight forward best-in-class design at a click of a button.',
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onHover: (value) {
                  if (value) {
                    setState(() => pricebuttonpapdding =
                        MaterialStateProperty.all(const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 30)));
                  } else {
                    setState(() => pricebuttonpapdding =
                        MaterialStateProperty.all(const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20)));
                  }
                },
                style: ButtonStyle(
                    padding: pricebuttonpapdding,
                    overlayColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.8)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.7)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)))),
                onPressed: () {},
                child: const Text(
                  'View Pricing',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(100)),
                child: Column(
                  children: [
                    Text(
                      'Our Services',
                      style: _bodytextstyle,
                    ),
                    Image.asset(
                      'assets/services.png',
                      width: size.width * 0.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          )
        ],
      ),
    );
  }
}

class MyCustomAppbar extends StatefulWidget {
  const MyCustomAppbar({Key? key}) : super(key: key);

  @override
  State<MyCustomAppbar> createState() => _MyCustomAppbarState();
}

class _MyCustomAppbarState extends State<MyCustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Design Buddy',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Pricing',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Work',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'About Me',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'FAQ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.8)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.7)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                onPressed: () {},
                child: const Text('Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
