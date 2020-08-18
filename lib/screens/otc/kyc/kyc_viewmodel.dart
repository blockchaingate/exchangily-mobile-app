import 'dart:convert';
import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/otc_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'dart:io' as Io;

class KycViewModel extends BaseViewModel {
  final log = getLogger('KycViewModel');

  SharedService sharedService = locator<SharedService>();
  OtcService otcService = locator<OtcService>();
  File imageFile;
  final picker = ImagePicker();
  BuildContext context;

  String photoIdBase46Encode = '';
  String personalPhotoBase46Encode = '';
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final citizenship = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final city = TextEditingController();
  final province = TextEditingController();
  final postalCode = TextEditingController();
  final countryOfResidense = TextEditingController();

/*----------------------------------------------------------------------
                Select Image and convert to base64
----------------------------------------------------------------------*/

  Future getImage(String image) async {
    setBusy(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    final bytes = imageFile.readAsBytesSync();

    switch (image) {
      case 'photoId':
        photoIdBase46Encode = sharedService.convertImageToBase64(bytes);
        break;
      case 'personalPhoto':
        personalPhotoBase46Encode = sharedService.convertImageToBase64(bytes);
        break;
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                  Form Text Field Validation
----------------------------------------------------------------------*/

  formTextFieldValidation(value) {
    print(value);
    if (value.isEmpty) {
      return 'Please fill this field';
    }
    return null;
  }

/*----------------------------------------------------------------------
                        Form Submit Button
----------------------------------------------------------------------*/

  formSubmit() async {
    if (formKey.currentState.validate()) {
      Map body = {
        "app": SharedService.appName,
        "memberId": SharedService.campaignAppId,
        "name": name.text,
        "countryOfBirth": citizenship.text,
        "accreditedInvestor": false,
        "dateOfBirth": "1980-06-06",
        "countryOfResidency": countryOfResidense.text,
        "homeAddress": address1.text,
        "homeAddress2": address2.text,
        "city": city.text,
        "province": province.text,
        "postalCode": postalCode.text,
        "email": email.text,
        "photoUrls": [photoIdBase46Encode, personalPhotoBase46Encode]
      };
      await otcService.kycCreate(body).then((res) {
        if (res != null)
          sharedService.showInfoFlushbar('Form Validated Success', 'Good',
              Icons.check_box, green, context);
      });
    } else {
      sharedService.alertDialog(
          'Form Validated Failed', 'Please try again with correct information');
    }
  }
}
