import 'package:equatable/equatable.dart';

class menuEntry extends Equatable {
  final String id;
  final String name;
  final String desc;
  final List<menuEntry> child;
  // final Widget? information;

  const menuEntry({
    required this.id,
    required this.name,
    required this.desc,
    this.child = const [],
    // this.information,
  });

  factory menuEntry.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['child'] as List? ?? [];
    List<menuEntry> children = childrenFromJson.map((i) => menuEntry.fromJson(i)).toList();

    return menuEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      child: children,
    );
  }

  menuEntry copyWith({
    String? id,
    String? name,
    String? desc,
    List<menuEntry>? child,
    // Widget? information,
  }) {
    return menuEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      child: child ?? this.child,
      // information: information ?? this.information,
    );
  }

  menuEntry addChild(menuEntry newChild) {
    return copyWith(child: [...child, newChild]);
  }

  @override
  // List<Object?> get props => [id, name, desc, child, information];
  List<Object?> get props => [id, name, desc, child];

}
