import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/otc_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class KycViewModel extends BaseViewModel {
  final log = getLogger('KycViewModel');

  SharedService sharedService = locator<SharedService>();

  ApiService apiService = locator<ApiService>();
  OtcService otcService = locator<OtcService>();

  final picker = ImagePicker();
  BuildContext context;

  String photoIdBase64Encode = '';
  File photoIdFile;
  String personalPhotoBase64Encode = '';
  File personalPhotoFile;
  String citizenship;
  String countryOfResidense;
  DateTime selectedDate;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final dob = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final city = TextEditingController();
  final province = TextEditingController();
  final postalCode = TextEditingController();
  // final countryOfResidense = TextEditingController();
  final List<String> countryList = [];

/*----------------------------------------------------------------------
                        INIT
----------------------------------------------------------------------*/
  init() {
    getCountryList();
  }

/*----------------------------------------------------------------------
                        Show Date Picker
----------------------------------------------------------------------*/

  datePicker() async {
    selectedDate = await sharedService.showCalendar();
    print(selectedDate);
    String holder = selectedDate.toString();
    dob.text = holder.split(' ')[0];
  }

/*----------------------------------------------------------------------
                        Get Country List
----------------------------------------------------------------------*/
  getCountryList() async {
    setBusy(true);
    await apiService.getCountryList().then((res) {
      if (res != null) {
        List countries = res;
        countries.forEach((country) {
          countryList.add(country['name']['official']);
        });
        // log.i(countryList);
      }
    });

    setBusy(false);
  }

/*----------------------------------------------------------------------
                Select Image and convert to base64
----------------------------------------------------------------------*/

  Future getImage(String image) async {
    setBusy(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File imageFilePath = File(pickedFile.path);

    switch (image) {
      case 'photoId':
        photoIdFile = imageFilePath;
        Uint8List bytes = photoIdFile.readAsBytesSync();
        photoIdBase64Encode = sharedService.convertImageToBase64(bytes);
        break;
      case 'personalPhoto':
        personalPhotoFile = imageFilePath;
        Uint8List bytes = personalPhotoFile.readAsBytesSync();
        personalPhotoBase64Encode = sharedService.convertImageToBase64(bytes);
        break;
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                  Form Text Field Validation
----------------------------------------------------------------------*/

  formTextFieldValidation(value) {
    if (value != null) {
      print(value);
      if (value.isEmpty) {
        return 'Please fill this field';
      }
    }
    return null;
  }

/*----------------------------------------------------------------------
                        Form Submit Button
----------------------------------------------------------------------*/

  formSubmit() async {
    setBusy(true);
    if (formKey.currentState.validate()) {
      // REFORMAT DATE HERE
      Map<String, dynamic> body = {
        "app": SharedService.appName,
        "memberId": SharedService.campaignAppId,
        "name": name.text,
        "countryOfBirth": citizenship,
        "accreditedInvestor": false,
        "dateOfBirth": dob.text,
        "countryOfResidency": countryOfResidense,
        "homeAddress": address1.text,
        "homeAddress2": address2.text,
        "city": city.text,
        "province": province.text,
        "postalCode": postalCode.text,
        "email": email.text,
        "photoUrls": [photoIdBase64Encode, personalPhotoBase64Encode]
      };
      await kycCreate(body);
    } else {
      sharedService.alertDialog(
          'Form Validated Failed', 'Please try again with correct information');
    }
    setBusy(false);
  }

  // kyc create call to service
  kycCreate(body) async {
    await otcService.kycCreate(body).then((res) {
      if (res != null) {
        if (res['errors'] != null) {
          sharedService.alertDialog(
              'Form Notice', 'Please fill the form correctly and try again');
          log.e(res['errors']);
          return;
        }
        sharedService.showInfoFlushbar(
            'Submission Notice',
            'Your KYC application has been submitted successfully',
            Icons.check_box,
            green,
            context);
      }
    }).catchError((err) {
      log.e('kyc Create catch $err');
      sharedService.showInfoFlushbar(
          'Submission Notice',
          'Your KYC application has failed to submit',
          Icons.cancel,
          red,
          context);
    });
  }
}
