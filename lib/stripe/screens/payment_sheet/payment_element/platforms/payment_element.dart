import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Future<void> pay() async => throw UnimplementedError();

class PlatformPaymentElement extends StatelessWidget {
  const PlatformPaymentElement(this.clientSecret, {super.key});

  final String? clientSecret;

  @override
  Widget build(BuildContext context) => Container();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('clientSecret', clientSecret));
  }
}
