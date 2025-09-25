import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/model/menu.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import 'drag_menu_item.dart';
import 'final_drop_target.dart';


class BoardMenu extends StatelessWidget {
  final List<MenuItem> item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;
  final List<Color> colorCodes;

  const BoardMenu({
    super.key,
    required this.item,
    this.onItemTap,
    this.colorCodes= const <Color>[Colors.black, Colors.blue, Colors.redAccent, Colors.brown],
    this.selectedMenuItem,
    this.expandedItemId,
    // this.colorTextMenuItem = Colors.black,
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
            hintStyle: TextStyle(color: Colors.grey) ?? null,
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
              if (index < item.length) {
                return DragMenuItem(
                  item: item[index],
                  level: 0,
                  parentId: null, // <-- Các mục gốc không có cha
                  colorCodes: colorCodes,
                  onItemTap: onItemTap,
                  selectedMenuItem: selectedMenuItem,
                  expandedItemId: expandedItemId,
                );
              } else if (index == item.length && item.isNotEmpty) {
                // Final drop target for the root list
                return FinalDropTarget(
                  lastItem: item.last,
                  level: 0,
                  parentId: null,
                );
              } else {
                return addNewItemWidget(context);
              }
            },
          ),
        ),
      ],
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;
  final int level;
  final List<Color> colorCodes;

  const MenuItemWidget({
    super.key,
    required this.item,
    required this.level,
    required this.colorCodes,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorCodes.isNotEmpty ? colorCodes[level % colorCodes.length] : Colors.black;

    if (item.child.isNotEmpty) {
      // Menu.child isNotEmpty
      return ExpansionMenu(
        item: item,
        level: level,
        colorCodes: colorCodes,
        colorText: color,
        onItemTap: onItemTap,
        selectedMenuItem: selectedMenuItem,
        expandedItemId: expandedItemId,
      );
    }

    // if Menu.child isEmpty
    return NonChildMenu(
      item: item,
      onItemTap: onItemTap,
      selectedMenuItem: selectedMenuItem,
      colorText: color,
    );
  }
}

class NonChildMenu extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final Color? colorText;
  
  const NonChildMenu({
    super.key,
    required this.item,
    this.onItemTap,
    this.selectedMenuItem,
    this.colorText,
  });

  @override
  State<NonChildMenu> createState() => _NonChildMenuState();
}

class _NonChildMenuState extends State<NonChildMenu> {
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
              hintStyle: TextStyle(color: Colors.grey) ?? null,
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              border:  widget.selectedMenuItem?.id == widget.item.id ? Border.all(color: Colors.redAccent, width: 1,) : null,
            ),
            child: ListTile(
              leading: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Icon(Icons.drag_indicator_rounded),
              ),
              title: Text(
                  widget.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.colorText,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )
              ),
              // trailing: Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(widget.item.desc),
              //     if (_showAddChild)
              //       Icon(
              //         Icons.expand_less,
              //         color: Colors.blue.shade700,
              //       ),
              //   ],
              // ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              dense: true,
              onTap: () {
                // Call onItemTap callback first
                if (widget.onItemTap != null) {
                  widget.onItemTap!(widget.item);
                }
                setState(() {
                  _showAddChild = !_showAddChild;
                });
                print('Tapped on: ${widget.item.name}');
              },
            ),
          ),
          if (_showAddChild)
            addChildItemWidget(),
        ],
      ),
    );
  }
}

class ExpansionMenu extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;
  final Color? colorText;
  final int level;
  final List<Color> colorCodes;
  const ExpansionMenu({
    super.key,
    required this.item,
    this.colorText,
    required this.level,
    required this.colorCodes,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  State<ExpansionMenu> createState() => _ExpansionMenuState();
}

class _ExpansionMenuState extends State<ExpansionMenu> {
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
              hintStyle: TextStyle(color: Colors.grey) ?? null,
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              border:  widget.selectedMenuItem?.id == widget.item.id ? Border.all(color: Colors.redAccent, width: 1,) : null,
            ),
            child: ListTile(
              leading: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Icon(Icons.drag_indicator_rounded),
              ),
              title: Text(
                  widget.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.colorText ?? Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,

                  ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              dense: true,
              onTap: () {

                if (widget.onItemTap != null) {
                  widget.onItemTap!(widget.item);
                }
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                print('Tapped on: ${widget.item.name}');
              },
            ),
          ),

          if (_isExpanded) ...[
            ...widget.item.child.map(
              (childItem) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 2),
                child: DragMenuItem(
                  item: childItem,
                  onItemTap: widget.onItemTap,
                  selectedMenuItem: widget.selectedMenuItem,
                  expandedItemId: widget.expandedItemId,
                  level: widget.level + 1,
                  parentId: widget.item.id,
                  colorCodes: widget.colorCodes,
                ),
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
