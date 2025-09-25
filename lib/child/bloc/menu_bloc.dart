import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_menu_demo/child/view/info_widgets/detailed_card_info.dart';
import 'package:list_menu_demo/child/view/info_widgets/icon_info.dart';
import 'package:list_menu_demo/child/view/info_widgets/simple_text_info.dart';
import '../../model/menu.dart';
// import '../model/Menu.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuInitial()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<AddRootItemEvent>(_onAddRootItem);
    on<AddChildItemEvent>(_onAddChildItem);
    on<ReorderMenuItemsEvent>(_onReorderMenuItems);
  }

  void _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) {
    emit(const MenuLoading());

    final menuItems = [
      const MenuItem(
        id: '1',
        name: 'TRAINING 1: Đi làm phải thế',
        desc: 'Description for menu 1',
        information: SimpleTextInfo(text: 'This is information for Main Menu 1'),
        child: [
          MenuItem(
            id: '1.1',
            name: 'Buổi 1 - Giới thiệu chung & ádasdasdadsasda',
            desc: 'Sub description 1.1',
            information: IconInfo(icon: Icons.star),
          ),
          MenuItem(
            id: '1.2',
            name: 'Buổi 2- Tiến độ & Tiêu chuẩn ádasdasdsadasdsd',
            desc: 'Sub description 1.2',
            information: DetailedCardInfo(
              icon: Icons.info,
              title: 'Detailed Information for 1.2',
            ),
            child: [
              MenuItem(
                id: '1.2.1',
                name: 'Inner Menu 1.2.1',
                desc: 'Sub description 1.2.1',
                information: SimpleTextInfo(text: 'Details for inner menu 1.2.1'),
              ),
            ],
          ),
        ],
      ),
      const MenuItem(
        id: '2',
        name: 'Main Menu 2',
        desc: 'Description for menu 2',
        information: SimpleTextInfo(text: 'This is information for Main Menu 2'),
        child: [
          MenuItem(
            id: '2.1',
            name: 'Sub Menu 2.1',
            desc: 'Sub description 2.1',
            information: null,
          ),
        ],
      ),
    ];
    
    emit(MenuLoaded(menuItems));
  }

  void _onAddRootItem(AddRootItemEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      final newId = (currentState.menuItems.length + 1).toString();
      
      final newItem = MenuItem(
        id: newId,
        name: event.name,
        desc: 'New description',
        information: Center(child: Text('Newly added item')),
      );
      
      final updatedItems = [...currentState.menuItems, newItem];
      emit(MenuLoaded(updatedItems));
    }
  }

  void _onAddChildItem(AddChildItemEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      final updatedItems = _addChild2Parent(
        currentState.menuItems,
        event.parentId,
        event.childName,
      );
      emit(MenuLoaded(updatedItems, newlyAddedParentId: event.parentId));
    }
  }

  void _onReorderMenuItems(ReorderMenuItemsEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      final updatedItems = _reorderChildItems(
        currentState.menuItems,
        event.draggedItem,
        event.targetItem,
        event.position,
      );
      emit(MenuLoaded(updatedItems));
    }
  }

  List<MenuItem> _reorderChildItems(
    List<MenuItem> items,
    MenuItem draggedItem,
    MenuItem targetItem,
    DropPosition position,
  ) {
    final draggedIndex = items.indexWhere((item) => item.id == draggedItem.id);
    final targetIndex = items.indexWhere((item) => item.id == targetItem.id);

    // find draggedIndex and  targetIndex
    if (draggedIndex != -1 && targetIndex != -1) {
      final reorderedItems = List<MenuItem>.from(items);
      final itemToMove = reorderedItems.removeAt(draggedIndex);
      final newTargetIndex = reorderedItems.indexWhere((item) => item.id == targetItem.id);
      
      if (position == DropPosition.after) {
        reorderedItems.insert(newTargetIndex + 1, itemToMove);
      } else {
        reorderedItems.insert(newTargetIndex, itemToMove);
      }
      return reorderedItems;
    }

    return items.map((item) {
      if (item.child.isNotEmpty) {
        final updatedChildren = _reorderChildItems(
          item.child,
          draggedItem,
          targetItem,
          position,
        );
        return item.copyWith(child: updatedChildren);
      }
      return item;
    }).toList();
  }

  List<MenuItem> _addChild2Parent(
    List<MenuItem> items,
    String parentId,
    String childName,
  ) {
    return items.map((item) {
      if (item.id == parentId) {
        // add new child
        final newChildId = '${item.id}.${item.child.length + 1}';
        // final newChildId = '${item.id+1}';

        final newChild = MenuItem(
          id: newChildId,
          name: childName,
          desc: 'New description',
          information: null,
        );
        return item.addChild(newChild);
      } else if (item.child.isNotEmpty) {

        final updatedChildren = _addChild2Parent(
          item.child,
          parentId,
          childName,
        );
        return item.copyWith(child: updatedChildren);
      }
      return item;
    }).toList();
  }
}
