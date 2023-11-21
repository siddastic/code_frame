import 'package:code_frame/constants/seed_actions.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class ActionsProvider extends ChangeNotifier {
  final List<String> _actions = [...SEED_ACTIONS];

  List<String> get actions => _actions;

  void addAction(String action) {
    _actions.add(action);
    notifyListeners();
  }

  void removeActionAtIndex(int index) {
    _actions.removeAt(index);
    notifyListeners();
  }
}
