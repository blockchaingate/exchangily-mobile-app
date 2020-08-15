import 'dart:io';

import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class KycViewModel extends BaseViewModel {
  final log = getLogger('KycViewModel');

  File image;
  final picker = ImagePicker();
  BuildContext context;

  Future getImage() async {
    setBusy(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    setBusy(false);
  }
}
