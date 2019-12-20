import 'package:exchangilymobileapp/view_models/base_model.dart';
import 'package:exchangilymobileapp/view_models/create_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service_locator.dart';

class BaseScreen<T extends BaseModel> extends StatelessWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  const BaseScreen({this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        builder: (context) => locator<T>(),
        child: Consumer<T>(builder: builder));
  }
}
