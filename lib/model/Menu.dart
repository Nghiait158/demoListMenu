import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String desc;
  final List<MenuItem> child;

  const MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    this.child = const[],
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
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      child: child ?? this.child,
    );
  }

  MenuItem addChild(MenuItem newChild) {
    return copyWith(child: [...child, newChild]);
  }

  @override
  List<Object?> get props => [id, name, desc, child];
}
