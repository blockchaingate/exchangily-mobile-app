/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:flutter/material.dart';

class BaseState extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // better state handling with error
  bool _busy = false;
  String? _errorMessage = '';
  String _message = '';

  bool get busy => _busy;
  String? get errorMessage => _errorMessage;
  String get message => _message;

  bool get hasErrorMessage => _errorMessage != null && _errorMessage!.isNotEmpty;
  bool get hasMessage => _message != null && _message.isNotEmpty;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
