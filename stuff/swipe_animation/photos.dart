import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoBrowser extends StatefulWidget {
  const PhotoBrowser(
      {super.key,
      required this.photoAssetPaths,
      required this.visiblePhotoIndex});
  final List<String> photoAssetPaths;
  final int visiblePhotoIndex;

  @override
  State<PhotoBrowser> createState() => _PhotoBrowserState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('visiblePhotoIndex', visiblePhotoIndex));
    properties
        .add(IterableProperty<String>('photoAssetPaths', photoAssetPaths));
  }
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int visiblePhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void _prevImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0
          ? visiblePhotoIndex - 1
          : widget.photoAssetPaths.length - 1;
    });
  }

  void _nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
          ? visiblePhotoIndex + 1
          : 0;
    });
  }

  Widget _buildPhotoControls() => Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _prevImage,
            child: const FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              alignment: Alignment.topLeft,
              child: ColoredBox(color: Colors.transparent),
            ),
          ),
          GestureDetector(
            onTap: _nextImage,
            child: const FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              alignment: Alignment.topRight,
              child: ColoredBox(color: Colors.transparent),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(widget.photoAssetPaths[visiblePhotoIndex],
              fit: BoxFit.cover),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SelectedPhotoIndicator(
                photoCount: widget.photoAssetPaths.length,
                visiblePhotoIndex: visiblePhotoIndex),
          ),
          _buildPhotoControls(),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('visiblePhotoIndex', visiblePhotoIndex));
  }
}

class SelectedPhotoIndicator extends StatelessWidget {
  const SelectedPhotoIndicator({
    super.key,
    required this.photoCount,
    required this.visiblePhotoIndex,
  });
  final int photoCount;
  final int visiblePhotoIndex;

  Widget _buildInactiveIndicator() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Container(
            height: 3.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
      );

  Widget _buildActiveIndicator() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Container(
            height: 3.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 2.0,
                    offset: Offset(0.0, 1.0),
                  ),
                ]),
          ),
        ),
      );

  List<Widget> _buildIndicators() {
    final indicators = <Widget>[];
    for (var i = 0; i < photoCount; ++i) {
      indicators.add(
        i == visiblePhotoIndex
            ? _buildActiveIndicator()
            : _buildInactiveIndicator(),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: _buildIndicators(),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('visiblePhotoIndex', visiblePhotoIndex));
    properties.add(IntProperty('photoCount', photoCount));
  }
}
