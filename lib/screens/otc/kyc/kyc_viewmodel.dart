import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/otc_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class KycViewModel extends BaseViewModel {
  final log = getLogger('KycViewModel');

  SharedService sharedService = locator<SharedService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();

  ApiService apiService = locator<ApiService>();
  OtcService otcService = locator<OtcService>();

  final picker = ImagePicker();
  BuildContext context;

  List<String> photoIdBase64Encode = [];
  List photoIdFile = [];
  List<String> personalPhotoBase64Encode = [];
  List personalPhotoFile = [];
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
  bool accreditedInvestor = false;

/*----------------------------------------------------------------------
                        INIT
----------------------------------------------------------------------*/
  init() {
    clearLists();
    getCountryList();
  }

/*----------------------------------------------------------------------
                        Clear Lists
----------------------------------------------------------------------*/

  clearLists() {
    photoIdBase64Encode = [];
    photoIdFile = [];
    personalPhotoBase64Encode = [];
    personalPhotoFile = [];
    log.i('Lists cleared');
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
    if (pickedFile == null) {
      sharedService.showInfoFlushbar(
          'Notice', 'Image selection failed', Icons.cancel, red, context);
      return;
    }
    File imageFilePath = File(pickedFile.path);

    switch (image) {
      case 'photoId':
        Uint8List bytes = imageFilePath.readAsBytesSync();
        photoIdBase64Encode.add(sharedService.convertImageToBase64(bytes));
        photoIdFile.add(imageFilePath);

        break;

      case 'personalPhoto':
        Uint8List bytes = imageFilePath.readAsBytesSync();
        personalPhotoBase64Encode
            .add(sharedService.convertImageToBase64(bytes));
        personalPhotoFile.add(imageFilePath);
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
        return 'Field is required';
      }
    }
    return null;
  }

/*----------------------------------------------------------------------
                        Form Submit Button
----------------------------------------------------------------------*/

  formSubmit() async {
    setBusy(true);
    log.e(formKey.currentState.validate());
    if (!formKey.currentState.validate()) {
      sharedService.alertDialog('Form Validation Failed',
          'Please fill all the form fields correctly');
      setBusy(false);
      return;
    } else if (photoIdFile == null || photoIdFile.length < 2) {
      sharedService.showInfoFlushbar(
          'Form Validation Failed',
          'Must provide your 2 valid identity photos',
          Icons.cancel,
          red,
          context);

      setBusy(false);
      return;
    } else if (personalPhotoFile == null || personalPhotoFile.length < 1) {
      sharedService.showInfoFlushbar('Form Validation Failed',
          'Must provide your selfie photo', Icons.cancel, red, context);
      setBusy(false);
      return;
    } else if (formKey.currentState.validate() && photoIdFile.length >= 2) {
      // Get member ID from campaign database which saved after campaign login
      String memberId = '';
      String loginToken = '';
      await campaignUserDatabaseService.getByEmail(email.text).then((res) {
        if (res != null) {
          memberId = res.id;
          loginToken = res.token;
        }
      });
      print('memberId $memberId');

      Map<String, dynamic> body = {
        "app": SharedService.appName,
        "memberId": memberId,
        "name": name.text,
        "countryOfBirth": citizenship,
        "accreditedInvestor": accreditedInvestor.toString(),
        "dateOfBirth": dob.text,
        "countryOfResidency": countryOfResidense,
        "homeAddress": address1.text,
        "homeAddress2": address2.text,
        "city": city.text,
        "province": province.text,
        "postalCode": postalCode.text,
        "email": email.text,
        "photoUrls": photoIdBase64Encode.join(' '),
        "selfieUrls": personalPhotoBase64Encode.join(' ')
      };
      await kycCreate(body, loginToken);
    }
    setBusy(false);
  }

  // kyc create call to service
  kycCreate(body, loginToken) async {
    await otcService.kycCreate(body, loginToken).then((res) {
      if (res != null) {
        if (res['errors'] != null) {
          sharedService.alertDialog(
              'Form Notice', 'Please fill the form correctly and try again');
          log.e(res['errors']);
          return;
        }
        if (res['name'] == 'TokenExpiredError') {
          sharedService.alertDialog(
              'Notice', 'Login session expired, Please login again');

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
