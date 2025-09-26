import 'package:flutter/material.dart';
import 'package:list_menu_demo/model/menu.dart';

class CustomMenuItemLevel0 extends StatelessWidget {
  final menuEntry item;
  final menuEntry? selectedMenuItem;
  final Color textColor;

  const CustomMenuItemLevel0({
    super.key,
    required this.item,
    this.selectedMenuItem,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: selectedMenuItem?.id == item.id
            ? Border.all(
                color: Colors.redAccent,
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        leading: const MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Icon(Icons.drag_indicator_rounded),
        ),
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
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
              child: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            )
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }
}

