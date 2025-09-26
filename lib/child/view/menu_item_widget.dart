import 'package:flutter/material.dart';

import '../../model/menu.dart';
import 'board_menu.dart';
import 'menu_item_branch.dart';
import 'menu_item_leaf.dart';

class MenuItemWidget extends StatelessWidget {
  final menuEntry item;
  final Function(menuEntry)? onItemTap;
  final menuEntry? selectedMenuItem;
  final String? expandedItemId;
  final int level;
  final Widget menuWidget;
  final MenuItemBuilder menuBuilder;

  const MenuItemWidget({
    super.key,
    required this.item,
    required this.level,
    required this.menuWidget,
    required this.menuBuilder,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  Widget build(BuildContext context) {
    if (item.child.isNotEmpty) {
      return MenuItemBranch(
        item: item,
        level: level,
        onItemTap: onItemTap,
        selectedMenuItem: selectedMenuItem,
        expandedItemId: expandedItemId,
        menuBuilder: menuBuilder,
        menuWidget: menuWidget,
      );
    }

    return MenuItemLeaf(
      item: item,
      onItemTap: onItemTap,
      selectedMenuItem: selectedMenuItem,
      menuWidget: menuWidget,
    );
  }
}

