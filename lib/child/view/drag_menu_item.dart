import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/model/menu.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import 'board_menu.dart';

class DragData {
  final MenuItem item;
  final int level;
  final String? parentId;

  DragData({
    required this.item,
    required this.level,
    this.parentId,
  });
}

class DragMenuItem extends StatefulWidget {
  final MenuItem item;
  final int level;
  final String? parentId;
  final List<Color> colorCodes;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;

  const DragMenuItem({
    super.key,
    required this.item,
    required this.level,
    this.parentId,
    required this.colorCodes,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  State<DragMenuItem> createState() => _DragMenuItemState();
}

class _DragMenuItemState extends State<DragMenuItem> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<DragData>(
      onWillAccept: (draggedData) {
        if (draggedData == null) return false;

        final bool isSameLevel = draggedData.level == widget.level;
        final bool isSameParent = draggedData.parentId == widget.parentId;
        final bool isNotItself = draggedData.item.id != widget.item.id;

        return isSameLevel && isSameParent && isNotItself;
      },
      onAccept: (draggedData) {
        context.read<MenuBloc>().add(ReorderMenuItemsEvent(
              draggedItem: draggedData.item,
              targetItem: widget.item,
              position: DropPosition.before,
            ));
      },
      builder: (context, candidateData, rejectedData) {
        bool isTarget = false;
        if (candidateData.isNotEmpty) {
          final firstCandidate = candidateData.first;
          if (firstCandidate != null) {
            final bool isSameLevel = firstCandidate.level == widget.level;
            final bool isSameParent = firstCandidate.parentId == widget.parentId;
            final bool isNotItself = firstCandidate.item.id != widget.item.id;

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
            LongPressDraggable<DragData>(
              data: DragData(item: widget.item, level: widget.level, parentId: widget.parentId),
              feedback: SizedBox(
                width: 350,
                child: Material(
                  elevation: 4,
                  child: MenuItemWidget(
                    item: widget.item,
                    level: widget.level,
                    colorCodes: widget.colorCodes,
                    onItemTap: widget.onItemTap,
                    selectedMenuItem: widget.selectedMenuItem,
                    expandedItemId: widget.expandedItemId,
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: MenuItemWidget(
                  item: widget.item,
                  level: widget.level,
                  colorCodes: widget.colorCodes,
                  onItemTap: widget.onItemTap,
                  selectedMenuItem: widget.selectedMenuItem,
                  expandedItemId: widget.expandedItemId,
                ),
              ),
              child: MenuItemWidget(
                item: widget.item,
                level: widget.level,
                colorCodes: widget.colorCodes,
                onItemTap: widget.onItemTap,
                selectedMenuItem: widget.selectedMenuItem,
                expandedItemId: widget.expandedItemId,
              ),
            ),
          ],
        );
      },
    );
  }
}
