import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Draggable Grid', home: HomePage());
}

const tables = [
  TableModal(id: 1, name: 'name1'),
  TableModal(id: 2, name: 'name2'),
  TableModal(id: 3, name: 'name3'),
  TableModal(id: 4, name: 'name4'),
  TableModal(id: 5, name: 'name5'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DraggableGridViewBuilder(
          isOnlyLongPress: false,
          dragCompletion: (list, beforeIndex, afterIndex) {
            print('onDragAccept: $beforeIndex -> $afterIndex');
          },
          dragFeedback: (list, index) => Material(
            color: Colors.green,
            child: SizedBox(
              width: 200,
              height: 150,
              child: list[index].child,
            ),
          ),
          dragPlaceHolder: (list, index) => Placeholder(
            child: Container(
              color: Colors.white,
            ),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 130,
              childAspectRatio: 1.3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: List.generate(tables.length, (i) {
            final table = tables[i];
            return DraggableGridItem(
              isDraggable: true,
              dragCallback: (context, afterIndex) {
                print('onDragUpdate: $afterIndex -> $afterIndex');
              },
              child: TableWidget(
                  isAssign: false,
                  table: table,
                  assignedTable: 0,
                  onTopTap: () {},
                  onBottomTap: () {}),
            );
          }),
        ),
      );
}

class TableWidget extends StatelessWidget {
  const TableWidget(
      {super.key,
      required this.table,
      required this.assignedTable,
      this.onTopTap,
      required this.isAssign,
      this.onBottomTap});
  final TableModal table;
  final int assignedTable;
  final bool isAssign;
  final Function()? onTopTap, onBottomTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTopTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: assignedTable == table.id
                  ? const Color.fromRGBO(152, 197, 117, 1)
                  : Colors.transparent,
              width: assignedTable == table.id ? 4 : 1,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  mouseCursor: SystemMouseCursors.basic,
                  onTap: onBottomTap,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      table.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TableModal>('table', table));
    properties.add(IntProperty('assignedTable', assignedTable));
    properties.add(DiagnosticsProperty<bool>('isAssign', isAssign));
    properties.add(ObjectFlagProperty<Function()?>.has('onTopTap', onTopTap));
    properties
        .add(ObjectFlagProperty<Function()?>.has('onBottomTap', onBottomTap));
  }
}

typedef DragCompletion = void Function(
    List<DraggableGridItem> list, int beforeIndex, int afterIndex);
typedef DragFeedback = Widget Function(List<DraggableGridItem> list, int index);
typedef DragChildWhenDragging = Widget Function(
    List<DraggableGridItem> list, int index);
typedef DragPlaceHolder = Placeholder Function(
    List<DraggableGridItem> list, int index);

class DraggableGridViewBuilder extends StatefulWidget {
  const DraggableGridViewBuilder({
    super.key,
    required this.gridDelegate,
    required this.children,
    required this.dragCompletion,
    this.isOnlyLongPress = true,
    this.dragFeedback,
    this.dragChildWhenDragging,
    this.dragPlaceHolder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });
  final List<DraggableGridItem> children;
  final bool isOnlyLongPress;
  final DragFeedback? dragFeedback;
  final DragChildWhenDragging? dragChildWhenDragging;
  final DragPlaceHolder? dragPlaceHolder;
  final DragCompletion dragCompletion;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  DraggableGridViewBuilderState createState() =>
      DraggableGridViewBuilderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<DraggableGridItem>('children', children));
    properties
        .add(DiagnosticsProperty<bool>('isOnlyLongPress', isOnlyLongPress));
    properties.add(
        ObjectFlagProperty<DragFeedback?>.has('dragFeedback', dragFeedback));
    properties.add(ObjectFlagProperty<DragChildWhenDragging?>.has(
        'dragChildWhenDragging', dragChildWhenDragging));
    properties.add(ObjectFlagProperty<DragPlaceHolder?>.has(
        'dragPlaceHolder', dragPlaceHolder));
    properties.add(ObjectFlagProperty<DragCompletion>.has(
        'dragCompletion', dragCompletion));
    properties.add(EnumProperty<Axis>('scrollDirection', scrollDirection));
    properties.add(DiagnosticsProperty<bool>('reverse', reverse));
    properties
        .add(DiagnosticsProperty<ScrollController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool?>('primary', primary));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(DiagnosticsProperty<bool>('shrinkWrap', shrinkWrap));
    properties
        .add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(
        DiagnosticsProperty<SliverGridDelegate>('gridDelegate', gridDelegate));
    properties.add(DiagnosticsProperty<bool>(
        'addAutomaticKeepAlives', addAutomaticKeepAlives));
    properties.add(DiagnosticsProperty<bool>(
        'addRepaintBoundaries', addRepaintBoundaries));
    properties.add(
        DiagnosticsProperty<bool>('addSemanticIndexes', addSemanticIndexes));
    properties.add(DoubleProperty('cacheExtent', cacheExtent));
    properties.add(IntProperty('semanticChildCount', semanticChildCount));
    properties.add(EnumProperty<DragStartBehavior>(
        'dragStartBehavior', dragStartBehavior));
    properties.add(EnumProperty<ScrollViewKeyboardDismissBehavior>(
        'keyboardDismissBehavior', keyboardDismissBehavior));
    properties.add(StringProperty('restorationId', restorationId));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class DraggableGridViewBuilderState extends State<DraggableGridViewBuilder> {
  @override
  void initState() {
    super.initState();
    assert(widget.children.isNotEmpty, 'Children must not be empty.');
    list = [...widget.children];
    orgList = [...widget.children];
    _isOnlyLongPress = widget.isOnlyLongPress;
  }

  @override
  void didUpdateWidget(DraggableGridViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.children.isNotEmpty, 'Children must not be empty.');

    list = [...widget.children];
    orgList = [...widget.children];
    _isOnlyLongPress = widget.isOnlyLongPress;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DraggableGridViewBuilder build');
    return GridView.builder(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      gridDelegate: widget.gridDelegate,
      itemBuilder: (_, index) {
        debugPrint('DraggableGridViewBuilder itemBuilder index: $index');
        return (!list[index].isDraggable)
            ? list[index].child
            : DragTargetGrid(
                index: index,
                onChangeCallback: () => setState(() {}),
                feedback: widget.dragFeedback?.call(list, index),
                childWhenDragging:
                    widget.dragChildWhenDragging?.call(orgList, index),
                placeHolder: widget.dragPlaceHolder?.call(orgList, index),
                dragCompletion: widget.dragCompletion,
              );
      },
      itemCount: list.length,
    );
  }
}

class DraggableGridItem {
  DraggableGridItem({
    required this.child,
    this.isDraggable = false,
    this.dragCallback,
  });

  final bool isDraggable;
  final Widget child;
  final Function(BuildContext context, bool isDragging)? dragCallback;
}

var _dragStarted = false;
var _dragEnded = true;
List<DraggableGridItem> orgList = [];
List<DraggableGridItem> list = [];
DraggableGridItem? _draggedGridItem;
bool _isOnlyLongPress = true;

class PressDraggableGridView extends StatelessWidget {
  const PressDraggableGridView({
    super.key,
    required this.index,
    required this.onDragCancelled,
    this.feedback,
    this.childWhenDragging,
  });
  final int index;
  final Widget? feedback;
  final Widget? childWhenDragging;
  final VoidCallback onDragCancelled;

  @override
  Widget build(BuildContext context) => Draggable(
        onDraggableCanceled: (_, __) => onDragCancelled(),
        onDragStarted: () {
          if (_dragEnded) {
            _dragStarted = true;
            _dragEnded = false;
          }
        },
        onDragEnd: (details) {
          _dragEnded = true;
          _dragStarted = false;
        },
        data: index,
        feedback: feedback ?? list[index].child,
        childWhenDragging:
            childWhenDragging ?? _draggedGridItem?.child ?? list[index].child,
        child: list[index].child,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(ObjectFlagProperty<VoidCallback>.has(
        'onDragCancelled', onDragCancelled));
  }
}

class LongPressDraggableGridView extends StatelessWidget {
  const LongPressDraggableGridView({
    required this.index,
    required this.onDragCancelled,
    this.feedback,
    this.childWhenDragging,
    super.key,
  });
  final int index;
  final Widget? feedback;
  final Widget? childWhenDragging;
  final VoidCallback onDragCancelled;

  @override
  Widget build(BuildContext context) => LongPressDraggable(
        onDraggableCanceled: (_, __) => onDragCancelled(),
        onDragCompleted: () {
          log('');
        },
        onDragStarted: () {
          if (_dragEnded) {
            _dragStarted = true;
            _dragEnded = false;
          }
        },
        onDragEnd: (details) {
          _dragEnded = true;
          _dragStarted = false;
        },
        data: index,
        feedback: feedback ?? list[index].child,
        childWhenDragging:
            childWhenDragging ?? _draggedGridItem?.child ?? list[index].child,
        child: list[index].child,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(ObjectFlagProperty<VoidCallback>.has(
        'onDragCancelled', onDragCancelled));
  }
}

class DragTargetGrid extends StatefulWidget {
  const DragTargetGrid({
    super.key,
    required this.index,
    required this.onChangeCallback,
    this.feedback,
    this.childWhenDragging,
    this.placeHolder,
    required this.dragCompletion,
  });
  final int index;
  final VoidCallback? onChangeCallback;
  final Widget? feedback;
  final Widget? childWhenDragging;
  final Placeholder? placeHolder;
  final DragCompletion? dragCompletion;

  @override
  DragTargetGridState createState() => DragTargetGridState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onChangeCallback', onChangeCallback));
    properties.add(ObjectFlagProperty<DragCompletion?>.has(
        'dragCompletion', dragCompletion));
  }
}

class DragTargetGridState extends State<DragTargetGrid> {
  static bool _draggedIndexRemoved = false;
  static int _lastIndex = -1;
  static int _draggedIndex = -1;

  @override
  Widget build(BuildContext context) => DragTarget(
        onAccept: (data) => setState(() => _onDragComplete(widget.index)),
        onLeave: (details) {},
        onWillAccept: (details) => true,
        onMove: (details) {
          list[widget.index].dragCallback?.call(context, true);

          /// Update state when item is moving.
          setState(() {
            _setDragStartedData(details, widget.index);
            _checkIndexesAreDifferent(widget.index);
            widget.onChangeCallback?.call();
          });
        },
        builder: (context, accepted, rejected) => _isOnlyLongPress
            ? LongPressDraggableGridView(
                index: widget.index,
                feedback: widget.feedback,
                childWhenDragging: widget.childWhenDragging,
                onDragCancelled: () => _onDragComplete(_lastIndex),
              )
            : PressDraggableGridView(
                index: widget.index,
                feedback: widget.feedback,
                childWhenDragging: widget.childWhenDragging,
                onDragCancelled: () => _onDragComplete(_lastIndex),
              ),
      );

  /// Set drag data when dragging start.
  void _setDragStartedData(DragTargetDetails<Object?> details, int index) {
    if (_dragStarted) {
      _dragStarted = false;
      _draggedIndexRemoved = false;
      _draggedIndex = int.tryParse(details.data.toString()) ?? -1;
      _draggedGridItem = DraggableGridItem(
          child: widget.placeHolder ?? const EmptyItem(), isDraggable: true);
      _lastIndex = _draggedIndex;
    }
  }

  void _checkIndexesAreDifferent(int index) {
    if (_draggedIndex != -1 && index != _lastIndex) {
      list.removeWhere((element) => (widget.placeHolder != null)
          ? element.child is Placeholder
          : element.child is EmptyItem);
      _lastIndex = index;
      if (_draggedIndex > _lastIndex) {
        _draggedGridItem = orgList[_draggedIndex - 1];
      } else {
        _draggedGridItem = orgList[(_draggedIndex + 1 >= list.length)
            ? _draggedIndex
            : _draggedIndex + 1];
      }
      if (_draggedIndex == _lastIndex) {
        _draggedGridItem = DraggableGridItem(
            child: widget.placeHolder ?? const EmptyItem(), isDraggable: true);
      }

      if (!_draggedIndexRemoved) {
        _draggedIndexRemoved = true;
        list.removeAt(_draggedIndex);
      }
      list.insert(
        _lastIndex,
        DraggableGridItem(
            child: widget.placeHolder ?? const EmptyItem(), isDraggable: true),
      );
    }
  }

  void _onDragComplete(int index) {
    if (_draggedIndex == -1) {
      return;
    }
    list.removeAt(index);
    list.insert(index, orgList[_draggedIndex]);
    orgList = [...list];
    _dragStarted = false;

    widget.onChangeCallback?.call();
    list[index].dragCallback?.call(context, false);
    widget.dragCompletion?.call(orgList, _draggedIndex, _lastIndex);
    _draggedIndex = -1;
    _lastIndex = -1;
    _draggedGridItem = null;
  }
}

class EmptyItem extends StatelessWidget {
  const EmptyItem({super.key});

  @override
  Widget build(BuildContext context) => Container(color: Colors.white);
}

class TableModal {
  const TableModal({
    required this.id,
    required this.name,
  });

  factory TableModal.fromJson(Map<String, dynamic> data) => TableModal(
      id: int.tryParse(data['id'].toString()) ?? 0,
      name: data['name'].toString());
  final int id;
  final String name;

  @override
  String toString() => 'Table(id: $id)';

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  TableModal copyWith({
    int? id,
    String? name,
  }) =>
      TableModal(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}
