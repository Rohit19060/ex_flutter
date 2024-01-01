import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

// Update info.plist for Permission
// Update MainActivity.kt for FlutterFragmentActivity instead of FlutterActivity
// Add Permission for BioMetric in AndroidManifest.xml

final auth = LocalAuthentication();

Future<void> canAuthenticate() async {
  final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  final canAuthenticate =
      canAuthenticateWithBiometrics || await auth.isDeviceSupported();

  debugPrint('Can Authenticate: $canAuthenticate');

  final availableBiometrics = await auth.getAvailableBiometrics();
  if (availableBiometrics.isNotEmpty) {
    debugPrint('BioMetrics Available');
  }
  if (availableBiometrics.contains(BiometricType.strong) ||
      availableBiometrics.contains(BiometricType.face)) {
    debugPrint('Either Strong or Face is Available');
  }

  try {
    final isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(biometricOnly: true));

    debugPrint('isAuthenticated: $isAuthenticated');
  } on PlatformException catch (e) {
    debugPrint(e.message);
    if (e.code == auth_error.notAvailable) {
      debugPrint('No Hardware Here');
    } else if (e.code == auth_error.notEnrolled) {
      debugPrint('Not Enrolled');
    } else {
      debugPrint('Error not Found');
    }
  }

  try {
    final isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: false));
    debugPrint('isAuthenticated: $isAuthenticated');
  } on PlatformException catch (e) {
    debugPrint(e.message);
    if (e.code == auth_error.notAvailable) {
      debugPrint('No Hardware Here');
    } else if (e.code == auth_error.notEnrolled) {
      debugPrint('Not Enrolled');
    } else {
      debugPrint('Error not Found');
    }
  }
}

Future<List<BiometricType>> getBiometrics() async {
  try {
    return await auth.getAvailableBiometrics();
  } on PlatformException catch (e) {
    debugPrint(e.toString());
    return <BiometricType>[];
  }
}

Future<bool> authenticateUser({required bool isBiometric}) async {
  try {
    final isAvailable = await auth.canCheckBiometrics;
    if (!isAvailable) {
      return false;
    }
    return await auth.authenticate(
        localizedReason: 'Please authenticate to use the feature');
  } on PlatformException catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String title = 'Local Authentication';
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const FingerprintPage(),
      );
}

class FingerprintPage extends StatefulWidget {
  const FingerprintPage({super.key});

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {
  final auth = LocalAuthentication();
  bool isAvailable = false;
  bool hasFingerprint = false;
  List<BiometricType> biometrics = [];

  @override
  void initState() {
    super.initState();
    checkData();
  }

  Future<void> checkData() async {
    isAvailable = await auth.canCheckBiometrics;
    biometrics = await getBiometrics();
    hasFingerprint = biometrics.contains(BiometricType.fingerprint);
    setState(() {});
    debugPrint('Is Available: $isAvailable');
    debugPrint('Biometrics: $biometrics');
    debugPrint('hasFingerprint: $hasFingerprint');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text(MyApp.title), centerTitle: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAvailable)
                  const Icon(Icons.check, color: Colors.green, size: 24)
                else
                  const Icon(Icons.close, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                const Text('Biometrics', style: TextStyle(fontSize: 24)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasFingerprint)
                  const Icon(Icons.check, color: Colors.green, size: 24)
                else
                  const Icon(Icons.close, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                const Text('Fingerprint', style: TextStyle(fontSize: 24)),
              ],
            ),
            const ElevatedButton(
              onPressed: canAuthenticate,
              child: Text('Test Authentication'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authenticate = await authenticateUser(isBiometric: true);
                if (authenticate && mounted) {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }
              },
              child: const Text('Finger Print'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authenticate = await authenticateUser(isBiometric: false);
                if (authenticate && mounted) {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }
              },
              child: const Text('Pattern or PIN'),
            ),
            ...biometrics
                .map(
                  (e) => TextButton(
                    child: Text(e.name),
                    onPressed: () async {
                      final authenticate =
                          await authenticateUser(isBiometric: true);
                      if (authenticate && mounted) {
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    },
                  ),
                )
                .toList(),
            const SizedBox(),
          ],
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<BiometricType>('biometrics', biometrics));
    properties.add(DiagnosticsProperty<bool>('hasFingerprint', hasFingerprint));
    properties.add(DiagnosticsProperty<bool>('isAvailable', isAvailable));
    properties.add(DiagnosticsProperty<LocalAuthentication>('auth', auth));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(MyApp.title)),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Home',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  child: const Text('Logout', style: TextStyle(fontSize: 20)),
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const FingerprintPage(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
