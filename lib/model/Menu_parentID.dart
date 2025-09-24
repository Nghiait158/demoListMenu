import 'package:equatable/equatable.dart';

class MenuItem_parentId extends Equatable {
  final String id;
  final String name;
  final String desc;
  final String? parentId;

  const MenuItem_parentId({
    required this.id,
    required this.name,
    required this.desc,
    this.parentId,
  });

  factory MenuItem_parentId.fromJson(Map<String, dynamic> json) {
    return MenuItem_parentId(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      parentId: json['parentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'parentId': parentId,
    };
  }

  MenuItem_parentId copyWith({
    String? id,
    String? name,
    String? desc,
    String? parentId,
  }) {
    return MenuItem_parentId(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      parentId: parentId ?? this.parentId,
    );
  }

  bool get isRoot => parentId == null;

  bool isParentOf(MenuItem_parentId other) {
    return other.parentId == id;
  }

  bool isChildOf(MenuItem_parentId other) {
    return parentId == other.id;
  }

  @override
  List<Object?> get props => [id, name, desc, parentId];
}
//
//
// {
//    id: '1',
//   name: 'Main Menu 2',
//   desc: 'Description for menu 2',
//   parent: null,
// }
// {
//    id: '2',
//   name: 'Main Menu 2',
//   desc: 'Description for menu 2',
//   parent: '1',
// }