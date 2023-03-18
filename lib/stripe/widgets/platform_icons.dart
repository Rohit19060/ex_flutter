import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DevicePlatform { ios, android, web }

DevicePlatform? get selectedPlatform {
  if (kIsWeb) {
    return DevicePlatform.web;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return DevicePlatform.android;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return DevicePlatform.ios;
  }
  return null;
}

class PlatformIcons extends StatelessWidget {
  const PlatformIcons({
    super.key,
    required this.supported,
  });

  final List<DevicePlatform> supported;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final p in DevicePlatform.values) ...[
            _PlatformIcon(supported: supported, platform: p),
            const SizedBox(width: 8),
          ]
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<DevicePlatform>('supported', supported));
  }
}

class _PlatformIcon extends StatelessWidget {
  const _PlatformIcon({
    required this.supported,
    required this.platform,
  });

  final List<DevicePlatform> supported;
  final DevicePlatform platform;

  @override
  Widget build(BuildContext context) {
    final isSupported = supported.contains(platform);
    final isCurrent = selectedPlatform == platform;
    final color = isSupported ? Colors.green[400]! : Colors.red[400]!;
    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? color : color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        platform.icon,
        size: 16,
        color: isCurrent ? Colors.white60 : color,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DevicePlatform>('platform', platform));
    properties.add(IterableProperty<DevicePlatform>('supported', supported));
  }
}

extension on DevicePlatform {
  IconData get icon {
    switch (this) {
      case DevicePlatform.ios:
        return FontAwesomeIcons.apple;
      case DevicePlatform.android:
        return FontAwesomeIcons.android;
      case DevicePlatform.web:
        return FontAwesomeIcons.chrome;
    }
  }
}
