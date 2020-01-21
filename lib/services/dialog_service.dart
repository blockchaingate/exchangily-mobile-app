import 'dart:async';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/alert/alert_request.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';

class DialogService {
  Function(AlertRequest) _showDialogListener;
  Completer<AlertResponse> _dialogCompleter;
  final log = getLogger('DialogService');
  // Registers a callback function, typically to show the dialog box
  void registerDialogListener(Function(AlertRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  // Calls the dialog listener and returns a future that will wait for the dialog to complete
  Future<AlertResponse> showDialog(
      {String title, String description, String buttonTitle}) {
    log.w('In show dialog');
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(AlertRequest(
        title: title, description: description, buttonTitle: buttonTitle));
    return _dialogCompleter.future;
  }

  // Completer the _dialogCompleter to resume the Future's execution
  void dialogComplete(AlertResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
