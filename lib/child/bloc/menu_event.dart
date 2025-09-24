import 'package:equatable/equatable.dart';
// import '../model/Menu.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class AddRootItemEvent extends MenuEvent {
  final String name;

  const AddRootItemEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class AddChildItemEvent extends MenuEvent {
  final String parentId;
  final String childName;

  const AddChildItemEvent({
    required this.parentId,
    required this.childName,
  });

  @override
  List<Object?> get props => [parentId, childName];
}

class LoadMenuEvent extends MenuEvent {
  const LoadMenuEvent();
}
