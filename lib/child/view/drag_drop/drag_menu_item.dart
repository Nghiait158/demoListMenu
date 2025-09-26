import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/model/menu.dart';

import '../../bloc/menu_bloc.dart';
import '../../bloc/menu_event.dart';

class DragData {
  final menuEntry item;
  final int level;
  final String? parentId;

  DragData({
    required this.item,
    required this.level,
    this.parentId,
  });
}

class DragMenuItem extends StatelessWidget {
  final menuEntry item;
  final int level;
  final String? parentId;
  final Widget child;

  const DragMenuItem({
    super.key,
    required this.item,
    required this.level,
    required this.child,
    this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragData>(
      onWillAccept: (draggedData) {
        if (draggedData == null) return false;

        final bool isSameLevel = draggedData.level == level;
        final bool isSameParent = draggedData.parentId == parentId;
        final bool isNotItself = draggedData.item.id != item.id;

        return isSameLevel && isSameParent && isNotItself;
      },
      onAccept: (draggedData) {
        context.read<MenuBloc>().add(ReorderMenuItemsEvent(
              draggedItem: draggedData.item,
              targetItem: item,
              position: DropPosition.before,
            ));
      },
      builder: (context, candidateData, rejectedData) {
        bool isTarget = false;
        if (candidateData.isNotEmpty) {
          final firstCandidate = candidateData.first;
          if (firstCandidate != null) {
            final bool isSameLevel = firstCandidate.level == level;
            final bool isSameParent = firstCandidate.parentId == parentId;
            final bool isNotItself = firstCandidate.item.id != item.id;

            if (isSameLevel && isSameParent && isNotItself) {
              isTarget = true;
            }
          }
        }

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              height: isTarget ? 40 : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isTarget
                  ? const Icon(Icons.arrow_downward, color: Colors.white, size: 16)
                  : null,
            ),
            Draggable<DragData>(
              data: DragData(item: item, level: level, parentId: parentId),
              feedback: SizedBox(
                width: 350,
                child: Material(
                  elevation: 4,
                  child: child,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: child,
              ),
              child: child,
            ),
          ],
        );
      },
    );
  }
}
