import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/menu.dart';
import 'package:flutter/material.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
class MenuItemLeaf extends StatefulWidget {
  final menuEntry item;
  final Function(menuEntry)? onItemTap;
  final menuEntry? selectedMenuItem;
  final Widget menuWidget;

  const MenuItemLeaf({
    super.key,
    required this.item,
    required this.menuWidget,
    this.onItemTap,
    this.selectedMenuItem,
  });

  @override
  State<MenuItemLeaf> createState() => _MenuItemLeafState();
}

class _MenuItemLeafState extends State<MenuItemLeaf> {
  bool _showAddChild = false;

  Widget addChildItemWidget() {
    final TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          // leading: const Icon(Icons.add, color: Colors.blue),
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
                _showAddChild = !_showAddChild;
              });
              print('Tapped on: ${widget.item.name}');
            },
            child: widget.menuWidget,
          ),
          if (_showAddChild)
            addChildItemWidget(),
        ],
      ),
    );
  }
}

