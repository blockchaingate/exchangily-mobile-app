import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TogglePasswordWidget extends StatelessWidget {
  final model;
  const TogglePasswordWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => model.togglePassword(),
        icon: !model.isShowPassword
            ? const Icon(
                Icons.remove_red_eye_outlined,
                color: primaryColor,
              )
            : const Icon(
                Icons.remove_red_eye,
                color: white,
              ));
  }
}
