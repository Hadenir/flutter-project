import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/navigation/page_config.dart';

class NavigationStack {
  final List<StarWarsDbPageConfig> _stack;

  List<Page> get pages => List.unmodifiable(_stack.map((x) => x.page));
  List<StarWarsDbPageConfig> get configs => _stack;
  int get length => _stack.length;
  StarWarsDbPageConfig get first => _stack.first;
  StarWarsDbPageConfig get last => _stack.last;

  NavigationStack(StarWarsDbPageConfig config) : _stack = [config];

  NavigationStack._(this._stack);

  bool canPop() => _stack.length > 1;

  NavigationStack pop() {
    if (canPop()) _stack.removeLast();
    return NavigationStack._(_stack);
  }

  NavigationStack push(StarWarsDbPageConfig config) {
    if (first == config) return this;

    _stack.add(config);
    return NavigationStack._(_stack);
  }

  NavigationStack replace(StarWarsDbPageConfig config) {
    _stack.removeLast();
    _stack.add(config);
    return NavigationStack._(_stack);
  }
}

class NavigationCubit extends Cubit<NavigationStack> {
  NavigationCubit(List<StarWarsDbPageConfig> initialPages) : super(NavigationStack._(initialPages));

  void pop() {
    emit(state.pop());
  }

  void push(StarWarsDbPageConfig config) {
    emit(state.push(config));
  }

  void replace(StarWarsDbPageConfig config) {
    emit(state.replace(config));
  }

  bool canPop() => state.canPop();
}
