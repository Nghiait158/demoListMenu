import 'package:flutter/material.dart';
import '../../../model/menu.dart';

class Level0ContentWidget extends StatelessWidget {
  final menuEntry menuItem;
  final Function(String parentId, String childName) onAddChild;

  const Level0ContentWidget({
    super.key,
    required this.menuItem,
    required this.onAddChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu Information Card
          // Card(
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.blue[50] ?? Colors.blue.shade50],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL 0=> Root',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    menuItem.desc,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          // ),
          // Add Child Widget
          _buildAddChildSection(),
        ],
      ),
    );
  }
  Widget _buildAddChildSection() {
    final TextEditingController controller = TextEditingController();

    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                hintText: 'Enter name for ${menuItem.name}',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
