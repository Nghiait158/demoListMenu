import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/model/menu.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import 'drag_drop/drag_menu_item.dart';
import 'menu_item_branch.dart';
import 'drag_drop/final_drop_target.dart';
import 'menu_item_leaf.dart';


typedef MenuItemBuilder = Widget Function(
    BuildContext context, menuEntry menuItem, int level);

class BoardMenu extends StatelessWidget {
  final List<menuEntry> item;
  final Function(menuEntry)? onItemTap;
  final menuEntry? selectedMenuItem;
  final String? expandedItemId;
  final MenuItemBuilder menuBuilder;

  const BoardMenu({
    super.key,
    required this.item,
    required this.menuBuilder,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  Widget addNewItemWidget(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            hintText: "Add new item...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight:FontWeight.bold,
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              context.read<MenuBloc>().add(AddRootItemEvent(value.trim()));
              controller.clear();
            }
          },
        ),
        dense: true,
        onTap: () {
          print('Add new item tapped');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Danh sách",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(right: 8),
            itemCount: item.length + 2,
            itemBuilder: (context, index) {

              if (index < item.length) { // return List Menu
                return menuBuilder(context, item[index], 0);

              } else if (index == item.length && item.isNotEmpty) { // return space for drop
                return FinalDropTarget(
                  lastItem: item.last,
                  level: 0,
                  parentId: null,
                );

              } else { // return add new root item
                return addNewItemWidget(context);
              }
            },
          ),
        ),
      ],
    );
  }
}
