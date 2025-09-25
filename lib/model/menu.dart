import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String desc;
  final List<MenuItem> child;
  final Widget? information;

  const MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    this.child = const [],
    this.information,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['child'] as List? ?? [];
    List<MenuItem> children = childrenFromJson.map((i) => MenuItem.fromJson(i)).toList();

    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      child: children,
    );
  }

  MenuItem copyWith({
    String? id,
    String? name,
    String? desc,
    List<MenuItem>? child,
    Widget? information,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      child: child ?? this.child,
      information: information ?? this.information,
    );
  }

  MenuItem addChild(MenuItem newChild) {
    return copyWith(child: [...child, newChild]);
  }

  @override
  List<Object?> get props => [id, name, desc, child, information];
}
