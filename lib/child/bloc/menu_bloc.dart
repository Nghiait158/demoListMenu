import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/Menu.dart';
// import '../model/Menu.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuInitial()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<AddRootItemEvent>(_onAddRootItem);
    on<AddChildItemEvent>(_onAddChildItem);
  }

  void _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) {
    emit(const MenuLoading());

    final menuItems = [
      const MenuItem(
        id: '1',
        name: 'Main Menu 1',
        desc: 'Description for menu 1',
        child: [
          MenuItem(
            id: '1.1',
            name: 'Sub Menu 1.1',
            desc: 'Sub description 1.1',
          ),
          MenuItem(
            id: '1.2',
            name: 'Sub Menu 1.2',
            desc: 'Sub description 1.2',
            child: [
              MenuItem(
                id: '1.2.1',
                name: 'Inner Menu 1.2.1',
                desc: 'Sub description 1.2.1',
              ),
            ],
          ),
        ],
      ),
      const MenuItem(
        id: '2',
        name: 'Main Menu 2',
        desc: 'Description for menu 2',
        child: [
          MenuItem(
            id: '2.1',
            name: 'Sub Menu 2.1',
            desc: 'Sub description 2.1',
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
