import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/child/bloc/menu_bloc.dart';
import 'package:list_menu_demo/child/bloc/menu_event.dart';
import 'package:list_menu_demo/child/view/drag_menu_item.dart';
import 'package:list_menu_demo/model/menu.dart';

class FinalDropTarget extends StatelessWidget {
  final MenuItem lastItem;
  final int level;
  final String? parentId;

  const FinalDropTarget({
    super.key,
    required this.lastItem,
    required this.level,
    this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragData>(
      onWillAccept: (draggedData) {
        if (draggedData == null) return false;

        final bool isSameLevel = draggedData.level == level;
        final bool isSameParent = draggedData.parentId == parentId;
        final bool isNotItself = draggedData.item.id != lastItem.id;

        return isSameLevel && isSameParent && isNotItself;
      },
      onAccept: (draggedData) {
        context.read<MenuBloc>().add(ReorderMenuItemsEvent(
              draggedItem: draggedData.item,
              targetItem: lastItem,
              position: DropPosition.after,
            ));
      },
      builder: (context, candidateData, rejectedData) {
        bool isTarget = false;
        if (candidateData.isNotEmpty) {
          final firstCandidate = candidateData.first;
          if (firstCandidate != null) {
            final bool isSameLevel = firstCandidate.level == level;
            final bool isSameParent = firstCandidate.parentId == parentId;
            final bool isNotItself = firstCandidate.item.id != lastItem.id;

            if (isSameLevel && isSameParent && isNotItself) {
              isTarget = true;
            }
          }
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          height: isTarget ? 40 : 10,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isTarget ? Colors.blue.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: isTarget
              ? const Icon(Icons.arrow_downward, color: Colors.white, size: 16)
              : null,
        );
      },
    );
  }
}

