import 'package:flutter/material.dart' show ChangeNotifier;

class HistoryProvider extends ChangeNotifier {
  final List<String> _historyActions = [];

  List<String> get actions => _historyActions;

  void addAction(String action) {
    _historyActions.add(action);
    notifyListeners();
  }

  void clearHistory() {
    _historyActions.clear();
    notifyListeners();
  }
}
