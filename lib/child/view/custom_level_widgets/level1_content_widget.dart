import 'package:flutter/material.dart';
import '../../../model/menu.dart';

class Level1ContentWidget extends StatelessWidget {
  final menuEntry menuItem;
  final Function(String parentId, String childName) onAddChild;

  const Level1ContentWidget({
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
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEVEL 1',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                ),
                const SizedBox(height: 20),
                Text(
                  menuItem.desc,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Add Item Section
          _buildAddItemSection(),
        ],
      ),
    );
  }

  Widget _buildAddItemSection() {
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
            hintText: 'Enter sub-item name for "${menuItem.name}"',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.green[25],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
