import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';

class TogglePasswordWidget extends StatelessWidget {
  final isShow;
  final Function(bool) togglePassword;
  const TogglePasswordWidget(
      {@required this.isShow, @required this.togglePassword});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          bool value = isShow;
          value = !value;
          togglePassword(value);
        },
        icon: isShow
            ? const Icon(
                FontAwesomeIcons.eye,
                color: yellow,
                size: 18,
              )
            : const Icon(
                FontAwesomeIcons.eyeSlash,
                color: white,
                size: 18,
              ));
  }
}
