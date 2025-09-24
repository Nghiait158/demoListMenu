import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/model/Menu.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';


class BoardMenu extends StatelessWidget {
  final List<MenuItem> item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;
  
  const BoardMenu({
    super.key,
    required this.item,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  Widget addNewItemWidget(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.add, color: Colors.blue),
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            hintText: "Add new item...",
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 15),
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
    return ListView.builder(
      padding: const EdgeInsets.only(right:8),
      itemCount: item.length + 1,
      itemBuilder: (context, index) {
        if (index < item.length) {
          return MenuItemWidget(
            item: item[index],
            onItemTap: onItemTap,
            selectedMenuItem: selectedMenuItem,
            expandedItemId: expandedItemId,
          );
        } else {
          return addNewItemWidget(context);
        }
      },
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  final String? expandedItemId;

  const MenuItemWidget({
    super.key,
    required this.item,
    this.onItemTap,
    this.selectedMenuItem,
    this.expandedItemId,
  });

  @override
  Widget build(BuildContext context) {
    if (item.child.isNotEmpty) {
      // Menu.child isNotEmpty
      return ExpansionMenu(
        item: item,
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
    );
  }
}

class NonChildMenu extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem)? onItemTap;
  final MenuItem? selectedMenuItem;
  
  const NonChildMenu({
    super.key,
    required this.item,
    this.onItemTap,
    this.selectedMenuItem,
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              hintText: "Add new child item...",
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 15),
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
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: widget.selectedMenuItem?.id == widget.item.id 
                  ? Colors.blue.withOpacity(0.2) 
                  : null,
            ),
            child: ListTile(
              leading: Text(widget.item.id),
              title: Text(widget.item.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.item.desc),
                  if (_showAddChild)
                    Icon(
                      Icons.expand_less,
                      color: Colors.blue.shade700,
                    ),
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
  
  const ExpansionMenu({
    super.key,
    required this.item,
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              hintText: "Add new itemaa..",
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 15),
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
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: widget.selectedMenuItem?.id == widget.item.id 
                  ? Colors.blue.withOpacity(0.2) 
                  : null,
            ),
            child: ListTile(
              leading: Text(widget.item.id),
              title: Text(widget.item.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.item.desc),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: _isExpanded ? Colors.blue.shade700 : Colors.blue.shade400,
                  ),
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
                child: MenuItemWidget(
                  item: childItem,
                  onItemTap: widget.onItemTap,
                  selectedMenuItem: widget.selectedMenuItem,
                  expandedItemId: widget.expandedItemId,
                ),
              ),
            ).toList(),

            //add new item  at the end
            addNewItemWidget(),
          ],
        ],
      ),
    );
  }
}
