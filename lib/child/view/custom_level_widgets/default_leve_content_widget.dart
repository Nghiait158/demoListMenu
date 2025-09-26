import 'package:flutter/material.dart';
import '../../../model/menu.dart';

class DefaultLevelContentWidget extends StatelessWidget {
  final menuEntry menuItem;
  final int level;
  final Function(String parentId, String childName) onAddChild;

  const DefaultLevelContentWidget({
    super.key,
    required this.menuItem,
    required this.level,
    required this.onAddChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            // Advanced Content Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.purple.shade100,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataField('Identifier', menuItem.id, Icons.fingerprint),
                  const SizedBox(height: 16),
                  _buildDataField('Title', menuItem.name, Icons.title),
                  const SizedBox(height: 16),
                  _buildDataField('Content', menuItem.desc, Icons.article),
                ],
              ),
            ),


            // Add Item Section
            _buildAdvancedAddSection(),
          ],
        ),
    );

  }
  Widget _buildDataField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[25],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedAddSection() {
    final TextEditingController controller = TextEditingController();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onAddChild(menuItem.id, value.trim());
                  controller.clear();
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter advanced item name for "${menuItem.name}"',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
  }

  IconData _getLevelIcon(int level) {
    const icons = [
      Icons.home,
      Icons.folder,
      Icons.description,
      Icons.apps,
      Icons.auto_awesome,
      Icons.psychology,
    ];
    return level < icons.length ? icons[level] : Icons.more_horiz;
  }
}
