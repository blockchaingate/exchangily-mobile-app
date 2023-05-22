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

import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen<T extends BaseState> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child)? builder;
  final void Function(T model)? onModelReady;

  const BaseScreen({Key? key, this.builder, this.onModelReady})
      : super(key: key);

  @override
  BaseScreenState<T> createState() => BaseScreenState<T>();
}

class BaseScreenState<T extends BaseState> extends State<BaseScreen<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = locator<T>();
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder!,
      ),
    );
  }
}


// class BaseScreen<T extends BaseState?> extends StatefulWidget {
//   final Widget Function(BuildContext context, T model, Widget? child)? builder;
//   final Function(T)? onModelReady;

//   const BaseScreen({Key? key, this.builder, this.onModelReady})
//       : super(key: key);

//   @override
//   BaseScreenState<T> createState() => BaseScreenState<T>();
// }

// class BaseScreenState<T extends BaseState?> extends State<BaseScreen<T?>> {
//   T model = locator<T>();

//   @override
//   void initState() {
//     if (widget.onModelReady != null) {
//       widget.onModelReady!(model);
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<T?>(
//         create: (context) => model,
//         child: Consumer<T>(builder: widget.builder!));
//   }
// }
