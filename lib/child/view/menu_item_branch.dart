
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/menu.dart';
import 'package:flutter/material.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import 'board_menu.dart';
import 'drag_drop/final_drop_target.dart';
class MenuItemBranch extends StatefulWidget {
  final menuEntry item;
  final Function(menuEntry)? onItemTap;
  final menuEntry? selectedMenuItem;
  final String? expandedItemId;
  final int level;
  final MenuItemBuilder menuBuilder;
  final Widget menuWidget;

  const MenuItemBranch({
    super.key,
    required this.item,
    required this.level,
    required this.menuBuilder,
    required this.menuWidget,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  State<MenuItemBranch> createState() => _MenuItemBranchState();
}

class _MenuItemBranchState extends State<MenuItemBranch> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.expandedItemId == widget.item.id) {
      _isExpanded = true;
    }
  }

  Widget addNewItemWidget() {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 2, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade50,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(
          //   color: Colors.black,
          //   width: 1,
          // ),
        ),
        child: ListTile(
          // leading: const Icon(Icons.add, color: Colors.blue),
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              hintText: "Add new item123...",
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
                context.read<MenuBloc>().add(AddChildItemEvent(
                  parentId: widget.item.id,
                  childName: value.trim(),
                ));
                controller.clear();
              }
            },
          ),
          dense: true,
          onTap: () {
            print('Add child item tapped');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1, bottom: 1, left: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onItemTap != null) {
                widget.onItemTap!(widget.item);
              }
              setState(() {
                _isExpanded = !_isExpanded;
              });
              print('Tapped on: ${widget.item.name}');
            },
            child: widget.menuWidget,
            // child: widget.menuWidget,
          ),

          if (_isExpanded) ...[
            ...widget.item.child.map(
                  (childItem) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 2),
                child: widget.menuBuilder(context, childItem, widget.level + 1),
              ),
            ).toList(),

            // if hav child
            if (widget.item.child.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 2),
                child: FinalDropTarget(
                  lastItem: widget.item.child.last,
                  level: widget.level + 1,
                  parentId: widget.item.id,
                ),
              ),

            //add new item  at the end
            addNewItemWidget(),
          ],
        ],
      ),
    );
  }
}
