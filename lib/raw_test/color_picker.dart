import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';

enum Images { assets, network }

void main() => runApp(const MyApp());

/// The main Application class.
class MyApp extends StatelessWidget {
  /// Creates the main Application class.
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Image Colors',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const WelcomeScreen());
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _imageController = TextEditingController();
  Images imageValue = Images.assets;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please Enter Images Link for which you want color'),
          if (imageValue == Images.network)
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Assets'),
              Radio(
                  value: Images.assets,
                  groupValue: imageValue,
                  onChanged: (val) {
                    setState(() {
                      imageValue = val as Images;
                    });
                  }),
              const Text('Network'),
              Radio(
                  value: Images.network,
                  groupValue: imageValue,
                  onChanged: (val) {
                    setState(() {
                      imageValue = val as Images;
                    });
                  }),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                final String value = _imageController.text;
                if (imageValue == Images.network) {
                  if (value.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please Input something');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageColors(
                          isNetwork: imageValue == Images.network,
                          url: _imageController.text,
                          imageSize: const Size(400, 400),
                        ),
                      ),
                    );
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageColors(
                        isNetwork: imageValue == Images.network,
                        url: _imageController.text,
                        imageSize: const Size(400, 400),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Change Image')),
        ],
      ),
    );
  }
}

/// The home page for this example app.
@immutable
class ImageColors extends StatefulWidget {
  /// Creates the home page.
  const ImageColors({
    Key? key,
    required this.imageSize,
    required this.isNetwork,
    required this.url,
  }) : super(key: key);

  /// The title that is shown at the top of the page.

  final String url;
  final bool isNetwork;

  /// This is the image provider that is used to load the colors from.

  /// The dimensions of the image.
  final Size imageSize;

  @override
  State<ImageColors> createState() {
    return _ImageColorsState();
  }
}

class _ImageColorsState extends State<ImageColors> {
  Rect? region;
  Rect? dragRegion;
  Offset? startDrag;
  Offset? currentDrag;
  PaletteGenerator? paletteGenerator;
  final GlobalKey imageKey = GlobalKey();
  Color _dominantColor = Colors.white;

  @override
  void initState() {
    super.initState();
    region = Offset.zero & widget.imageSize;
    _updatePaletteGenerator(region);
  }

  Future<void> _updatePaletteGenerator(Rect? newRegion) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      widget.isNetwork
          ? NetworkImage(widget.url) as ImageProvider
          : const AssetImage('assets/colored.jpg'),
      size: widget.imageSize,
      region: newRegion,
      maximumColorCount: 20,
    );

    setState(() {
      _dominantColor = paletteGenerator?.dominantColor?.color as Color;
    });
  }

  void _onPanDown(DragDownDetails details) {
    final RenderBox box =
        imageKey.currentContext!.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      startDrag = localPosition;
      currentDrag = localPosition;
      dragRegion = Rect.fromPoints(localPosition, localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentDrag = currentDrag! + details.delta;
      dragRegion = Rect.fromPoints(startDrag!, currentDrag!);
    });
  }

  void _onPanCancel() {
    setState(() {
      dragRegion = null;
      startDrag = null;
    });
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    final Size? imageSize = imageKey.currentContext?.size;
    Rect? newRegion;
    if (imageSize != null) {
      newRegion = (Offset.zero & imageSize).intersect(dragRegion!);
      if (newRegion.size.width < 4 && newRegion.size.width < 4) {
        newRegion = Offset.zero & imageSize;
      }
    }

    await _updatePaletteGenerator(newRegion);
    setState(() {
      region = newRegion;
      dragRegion = null;
      startDrag = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            // GestureDetector is used to handle the selection rectangle.
            child: GestureDetector(
              onPanDown: _onPanDown,
              onPanUpdate: _onPanUpdate,
              onPanCancel: _onPanCancel,
              onPanEnd: _onPanEnd,
              child: Stack(children: [
                widget.isNetwork
                    ? Image.network(
                        widget.url,
                        key: imageKey,
                        width: widget.imageSize.width,
                        height: widget.imageSize.height,
                      )
                    : Image.asset(
                        'assets/colored.jpg',
                        key: imageKey,
                        width: widget.imageSize.width,
                        height: widget.imageSize.height,
                      ),
                // This is the selection rectangle.
                Positioned.fromRect(
                    rect: dragRegion ?? region ?? Rect.zero,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1.0,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          )),
                    )),
              ]),
            ),
          ),
          // Use a FutureBuilder so that the palettes will be displayed when
          // the palette generator is done generating its data.
          PaletteSwatches(generator: paletteGenerator),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _dominantColor,
      ),
    );
  }
}

class PaletteSwatches extends StatelessWidget {
  const PaletteSwatches({Key? key, this.generator}) : super(key: key);

  final PaletteGenerator? generator;

  @override
  Widget build(BuildContext context) {
    final List<PaletteSwatch> swatches = [];
    final PaletteGenerator? paletteGen = generator;
    if (paletteGen == null || paletteGen.colors.isEmpty) {
      return const SizedBox();
    }
    for (final Color color in paletteGen.colors) {
      swatches.add(PaletteSwatch(color: color));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(children: swatches),
        Container(height: 30.0),
        PaletteSwatch(
            label: 'Dominant', color: paletteGen.dominantColor?.color),
        PaletteSwatch(
            label: 'Light Vibrant', color: paletteGen.lightVibrantColor?.color),
        PaletteSwatch(label: 'Vibrant', color: paletteGen.vibrantColor?.color),
        PaletteSwatch(
            label: 'Dark Vibrant', color: paletteGen.darkVibrantColor?.color),
        PaletteSwatch(
            label: 'Light Muted', color: paletteGen.lightMutedColor?.color),
        PaletteSwatch(label: 'Muted', color: paletteGen.mutedColor?.color),
        PaletteSwatch(
            label: 'Dark Muted', color: paletteGen.darkMutedColor?.color),
      ],
    );
  }
}

@immutable
class PaletteSwatch extends StatelessWidget {
  const PaletteSwatch({
    Key? key,
    this.color,
    this.label,
  }) : super(key: key);

  /// The color of the swatch.
  final Color? color;

  /// The optional label to display next to the swatch.
  final String? label;

  @override
  Widget build(BuildContext context) {
    // Compute the "distance" of the color swatch and the background color
    // so that we can put a border around those color swatches that are too
    // close to the background's saturation and lightness. We ignore hue for
    // the comparison.
    final HSLColor hslColor = HSLColor.fromColor(color ?? Colors.transparent);
    final HSLColor backgroundAsHsl = HSLColor.fromColor(Colors.white);
    final double colorDistance = math.sqrt(
        math.pow(hslColor.saturation - backgroundAsHsl.saturation, 2.0) +
            math.pow(hslColor.lightness - backgroundAsHsl.lightness, 2.0));

    Widget swatch = const SizedBox();

    if (label != null) {
      swatch = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130.0, minWidth: 130.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: color == null
                  ? const Placeholder(
                      fallbackWidth: 34.0,
                      fallbackHeight: 20.0,
                      color: Color(0xff404040),
                      strokeWidth: 2.0,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          width: 1.0,
                          color: Colors.red,
                          style: colorDistance < 0.2
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        ),
                      ),
                      width: 34.0,
                      height: 20.0,
                    ),
            ),
            Container(width: 5.0),
            Text(label!),
          ],
        ),
      );
    }
    return swatch;
  }
}
