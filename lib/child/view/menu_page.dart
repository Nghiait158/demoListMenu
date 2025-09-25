import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../../model/menu.dart';
import 'board_menu.dart';

class MenuPage_child extends StatelessWidget {
  const MenuPage_child({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(const LoadMenuEvent()),
      child: const MenuView(),
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  MenuItem? selectedMenuItem;

  void onMenuItemTap(MenuItem item) {
    setState(() {
      selectedMenuItem = item;
    });
  }

  Widget buildInformationPanel() {
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

    if (selectedMenuItem!.information != null) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: selectedMenuItem!.information!,
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 20),
          Text('Id: '+selectedMenuItem!.id),
          const SizedBox(height: 12),
          Text('Name: '+ selectedMenuItem!.name),
          const SizedBox(height: 12),
          Text('Description: '+ selectedMenuItem!.desc),
          const SizedBox(height: 20),
          _addNewChildItemWidget(),
        ],
      ),
    );
  }

  Widget _addNewChildItemWidget() {
    final TextEditingController controller = TextEditingController();

    void submitChild() {
      final value = controller.text.trim();
      if (value.isNotEmpty && selectedMenuItem != null) {
        context.read<MenuBloc>().add(AddChildItemEvent(
              parentId: selectedMenuItem!.id,
              childName: value,
            ));
        controller.clear();
        FocusScope.of(context).unfocus();
      }
    }

    return Padding(
        padding: EdgeInsets.only(left: 10, right:800),
      child: TextField(
        controller: controller,
        onSubmitted: (_) => submitChild(),
        decoration: InputDecoration(
          fillColor: Colors.blue.withOpacity(0.2),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          prefixIcon: Icon(Icons.add),
          hintText: 'Create new child for ' + selectedMenuItem!.name,
          // contentPadding: const EdgeInsets.symmetric(horizontal: 300, vertical: 15),
        ),
      ),
    );

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
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: buildInformationPanel(),
                ),
                Expanded(
                  flex: 1,
                  child: BoardMenu(
                    item: state.menuItems,
                    onItemTap: onMenuItemTap,
                    selectedMenuItem: selectedMenuItem,
                    expandedItemId: state.newlyAddedParentId,
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
