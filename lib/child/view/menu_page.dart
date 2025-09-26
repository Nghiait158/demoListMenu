import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../../model/menu.dart';
import 'board_menu.dart';
import 'custom_menu_item/custom_menu_item_level0.dart';
import 'custom_menu_item/custom_menu_item_level1.dart';
import 'custom_menu_item/custom_menu_item_level2.dart';
import 'drag_drop/drag_menu_item.dart';
import 'menu_item_widget.dart';
import 'information_panel.dart';

class MenuPage_child extends StatelessWidget {
  final Widget? informationPanel;
  final Widget? menuBuilder;
  const MenuPage_child({
    this.menuBuilder,
    super.key,
    this.informationPanel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(const LoadMenuEvent()),
      child: MenuView(menuBuilder: menuBuilder, informationPanel: informationPanel),
    );
  }
}

class MenuView extends StatefulWidget {
  final Widget? menuBuilder;
  final Widget? informationPanel;
  const MenuView({
    this.menuBuilder,
    this.informationPanel,
    super.key
  });

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  menuEntry? selectedMenuItem;

  void onMenuItemTap(menuEntry item) {
    setState(() {
      selectedMenuItem = item;
    });
  }


  void _handleAddChild(String parentId, String childName) {
    context.read<MenuBloc>().add(AddChildItemEvent(
      parentId: parentId,
      childName: childName,
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Menu Demo using child'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuLoaded) {
            late MenuItemBuilder menu;

            String? findParentId(String childId, List<menuEntry> entries) {
              for (final entry in entries) {
                if (entry.child.any((child) => child.id == childId)) {
                  return entry.id;
                }
                final foundId = findParentId(childId, entry.child);
                if (foundId != null) {
                  return foundId;
                }
              }
              return null;
            }

            menu = widget.menuBuilder == null ? (context, menuItem, level) {
              Widget menuWidget;
              switch (level) {
                case 0:
                  menuWidget = CustomMenuItemLevel0(
                    item: menuItem,
                    selectedMenuItem: selectedMenuItem,
                    textColor: Colors.black,
                  );
                  break;
                case 1:
                  menuWidget = CustomMenuItemLevel1(
                    item: menuItem,
                    selectedMenuItem: selectedMenuItem,
                    textColor: Colors.black,
                  );
                  break;
                case 2:
                  menuWidget = CustomMenuItemLevel2(
                    item: menuItem,
                    selectedMenuItem: selectedMenuItem,
                    textColor: Colors.black,
                  );
                  break;
                default:
                  menuWidget = ListTile(
                    title: Text(menuItem.name),
                    leading: menuItem.child.isNotEmpty ? const Icon(Icons.folder) : const Icon(Icons.description),
                  );
              }

              final parentId = findParentId(menuItem.id, state.menuItems);

              return DragMenuItem(
                item: menuItem,
                level: level,
                parentId: parentId,
                child: MenuItemWidget(
                  item: menuItem,
                  level: level,
                  onItemTap: onMenuItemTap,
                  selectedMenuItem: selectedMenuItem,
                  expandedItemId: state.newlyAddedParentId,
                  menuWidget: menuWidget,
                  menuBuilder: menu,
                ),
              );

              // if doesnt need dragDrop
              // return MenuItemWidget(
              //     item: menuItem,
              //     level: level,
              //     onItemTap: onMenuItemTap,
              //     selectedMenuItem: selectedMenuItem,
              //     expandedItemId: state.newlyAddedParentId,
              //     menuWidget: menuWidget,
              //     menuBuilder: menuBuilder,
              // );
            } : (context, menuItem, level) {return widget.menuBuilder!;};

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: widget.informationPanel == null
                      ?  InformationPanel(
                            selectedMenuItem: selectedMenuItem,
                            allMenuItems: state.menuItems,
                            onAddChild: _handleAddChild,
                        )
                      : widget.informationPanel!,
                ),
                Expanded(
                  flex: 1,
                  child: BoardMenu(
                    item: state.menuItems,
                    onItemTap: onMenuItemTap,
                    selectedMenuItem: selectedMenuItem,
                    expandedItemId: state.newlyAddedParentId,
                    menuBuilder: menu,
                    // menuContentbuilder:
                  ),
                )
              ],
            );
          } else if (state is MenuError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
