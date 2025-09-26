import 'package:flutter/material.dart';
import '../../../model/menu.dart';

class Level2ContentWidget extends StatelessWidget {
  final menuEntry menuItem;
  final Function(String parentId, String childName) onAddChild;

  const Level2ContentWidget({
    super.key,
    required this.menuItem,
    required this.onAddChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  'LEVEL 2',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'MenuItem: $menuItem',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            // Action Section
            _buildActionSection(),
          ],
        ),
    );
  }
  Widget _buildActionSection() {
    final TextEditingController controller = TextEditingController();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onAddChild(menuItem.id, value.trim());
                controller.clear();
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter detail item name...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
    );
  }
}
