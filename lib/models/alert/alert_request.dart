import 'package:flutter/cupertino.dart';

class AlertRequest {
  final String title;
  final String description;
  final String buttonTitle;

  AlertRequest(
      {@required this.title, this.description, @required this.buttonTitle});
}
