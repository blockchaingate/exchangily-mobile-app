import 'dart:convert';
import 'dart:io';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'dart:io' as Io;

class KycViewModel extends BaseViewModel {
  final log = getLogger('KycViewModel');

  SharedService sharedService = locator<SharedService>();
  File image;
  final picker = ImagePicker();
  BuildContext context;
  String base46Encode = '';

  Future getImage() async {
    setBusy(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    final bytes = image.readAsBytesSync();
    sharedService.convertImageToBase64(bytes);
    setBusy(false);
  }
}
