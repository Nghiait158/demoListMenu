import 'package:equatable/equatable.dart';

import '../../model/Menu.dart';
// import '../model/Menu.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final String? newlyAddedParentId;

  const MenuLoaded(this.menuItems, {this.newlyAddedParentId});

  @override
  List<Object?> get props => [menuItems, newlyAddedParentId];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}
