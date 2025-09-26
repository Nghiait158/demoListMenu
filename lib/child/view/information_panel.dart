import 'package:flutter/material.dart';
import '../../model/menu.dart';
import 'custom_level_widgets/level0_content_widget.dart';
import 'custom_level_widgets/level1_content_widget.dart';
import 'custom_level_widgets/level2_content_widget.dart';
import 'custom_level_widgets/default_leve_content_widget.dart';

class InformationPanel extends StatelessWidget {
  final menuEntry? selectedMenuItem;
  final List<menuEntry> allMenuItems;
  final Function(String parentId, String childName) onAddChild;

  const InformationPanel({
    super.key,
    required this.selectedMenuItem,
    required this.allMenuItems,
    required this.onAddChild,
  });

  //find level of item
  int getMenuItemLevel(menuEntry targetItem, List<menuEntry> items, {int currentLevel = 0}) {
    for (final item in items) {
      if (item.id == targetItem.id) {
        return currentLevel;
      }
      if (item.child.isNotEmpty) {
        final level = getMenuItemLevel(targetItem, item.child, currentLevel: currentLevel + 1);
        if (level >= 0) {
          return level;
        }
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {

    if (selectedMenuItem == null) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Select a menu item to view details',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    final level = getMenuItemLevel(selectedMenuItem!, allMenuItems);

    switch (level) {
      case 0:
        return Level0ContentWidget(
          menuItem: selectedMenuItem!,
          onAddChild: onAddChild,
        );
      case 1:
        return Level1ContentWidget(
          menuItem: selectedMenuItem!,
          onAddChild: onAddChild,
        );
      case 2:
        return Level2ContentWidget(
          menuItem: selectedMenuItem!,
          onAddChild: onAddChild,
        );
      default:
        return DefaultLevelContentWidget(
          menuItem: selectedMenuItem!,
          level: level,
          onAddChild: onAddChild,
        );
    }
  }
}

