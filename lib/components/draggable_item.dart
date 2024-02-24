import 'package:flutter/material.dart';

enum Swipe { left, right, none }

/// Re-usable Component for creating horizontal stack of
/// widgets that can be swipped away.
class DraggableItem extends StatefulWidget {
  const DraggableItem(
      {super.key,
      required this.widget,
      required this.index,
      required this.swipeNotifier});
  final Widget widget;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;

  @override
  State<DraggableItem> createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: widget.index,
      feedback: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder(
          valueListenable: swipeNotifier,
          builder: (context, swipe, _) {
            return RotationTransition(
                turns: swipe != Swipe.none
                    ? swipe == Swipe.left
                        ? const AlwaysStoppedAnimation(-15 / 360)
                        : const AlwaysStoppedAnimation(15 / 360)
                    : const AlwaysStoppedAnimation(0),
                child: widget.widget);
          },
        ),
      ),
      onDragUpdate: (dragUpdateDetails) {
        // When dragged to right
        if (dragUpdateDetails.delta.dx > 0 &&
            dragUpdateDetails.globalPosition.dx >
                MediaQuery.of(context).size.width / 2) {
          swipeNotifier.value = Swipe.right;
        }
        // When dragged to left
        if (dragUpdateDetails.delta.dx < 0 &&
            dragUpdateDetails.globalPosition.dx <
                MediaQuery.of(context).size.width / 2) {
          swipeNotifier.value = Swipe.left;
        }
      },
      onDragEnd: (drag) {
        swipeNotifier.value = Swipe.none;
      },
      childWhenDragging: Container(color: Colors.transparent),
      child: widget.widget,
    );
  }
}
