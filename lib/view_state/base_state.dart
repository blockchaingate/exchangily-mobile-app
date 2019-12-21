import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:flutter/material.dart';

class BaseState extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
