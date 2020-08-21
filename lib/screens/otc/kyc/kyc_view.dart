import 'dart:convert';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/otc/kyc/kyc_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class KycView extends StatefulWidget {
  KycView({Key key}) : super(key: key);

  @override
  _KycViewState createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KycViewModel>.reactive(
      viewModelBuilder: () => KycViewModel(),
      onModelReady: (model) {
        model.context = context;
        model.init();
      },
      builder: (context, model, _) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('KYC'),
        ),
        body: model.isBusy
            ? Center(child: model.sharedService.loadingIndicator())
            : SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    print('1111');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: walletCardColor,
                          blurRadius: 10,
                          spreadRadius: 5),
                    ]),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    margin: EdgeInsets.only(
                        right: 15.0, bottom: 10, left: 0, top: 20),
                    //  color: walletCardColor,
                    child: Form(
                      key: model.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
/*----------------------------------------------------------------------
                        Header
----------------------------------------------------------------------*/
                          // Container(
                          //   padding: EdgeInsets.all(2),
                          //   decoration: BoxDecoration(
                          //       border: Border(
                          //           bottom: BorderSide(
                          //               color: primaryColor, width: 3.0))),
                          //   child: Center(
                          //     child: Column(
                          //       children: <Widget>[
                          //         Text(
                          //           'KYC',
                          //           style:
                          //               Theme.of(context).textTheme.headline2,
                          //         ),
                          //         FlatButton(
                          //           onPressed: () async {
                          //             model.campaignUserDatabaseService
                          //                 .getAll();

                          //             String memberId = '';

                          //             await model.campaignUserDatabaseService
                          //                 .getByEmail('barry100@exg.com')
                          //                 .then((res) {
                          //               memberId = res.id;
                          //               print('id $memberId');
                          //             });
                          //           },
                          //           child: Text('Test'),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),

/*----------------------------------------------------------------------
                        Full Name
----------------------------------------------------------------------*/
                          TextFormField(
                            controller: model.name,
                            validator: (value) =>
                                model.formTextFieldValidation(value),
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: white, width: 0.5)),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(color: white)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0.5, color: primaryColor),
                                ),
                                labelText: 'Full Name',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                isDense: true,
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: grey,
                                  size: 16,
                                )),
                            // controller: model.emailTextController,
                            keyboardType: TextInputType.text,
                          ),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                        Email
----------------------------------------------------------------------*/
                          TextFormField(
                            controller: model.email,
                            validator: (value) =>
                                model.formTextFieldValidation(value),
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: white, width: 0.5)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0.5, color: primaryColor),
                                ),
                                labelText: AppLocalizations.of(context).email,
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                isDense: true,
                                suffixIcon: Icon(
                                  Icons.email,
                                  color: grey,
                                  size: 16,
                                )),
                            // controller: model.emailTextController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                     Citizenship // Change it to dropdown
 ----------------------------------------------------------------------*/
                          model.isBusy
                              ? model.sharedService.loadingIndicator()
                              : _countryList('citizenship', model),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                      Date of Birth
 ----------------------------------------------------------------------*/

                          TextFormField(
                              //   onTap: () => model.datePicker(),
                              controller: model.dob,
                              validator: (value) =>
                                  model.formTextFieldValidation(value),
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: white, width: 0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 0.5, color: primaryColor),
                                  ),
                                  helperText:
                                      'To participate you must be 19 years of age and older',
                                  helperStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: yellow),
                                  labelText: 'YYYY-MM-DD',
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  isDense: true,
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.date_range,
                                        color: primaryColor,
                                        size: 16,
                                      ),
                                      onPressed: () async {
                                        print('trying to open caledar');
                                        await model.datePicker();
                                        print('after to open caledar');
                                        CalendarDatePicker(
                                            initialCalendarMode:
                                                DatePickerMode.day,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1930),
                                            lastDate: DateTime.now(),
                                            onDateChanged: (selectedDate) {
                                              model.dob.text =
                                                  selectedDate.toString();
                                              print(model.dob.text);
                                            });
                                      })),
                              // controller: model.emailTextController,
                              keyboardType: TextInputType.datetime),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                        Address
----------------------------------------------------------------------*/
                          TextFormField(
                            controller: model.address1,
                            validator: (value) =>
                                model.formTextFieldValidation(value),
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: white, width: 0.5)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0.5, color: primaryColor),
                                ),
                                labelText: 'Address Line 1',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                hintText: 'Street Address',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                isDense: true,
                                suffixIcon: Icon(
                                  Icons.streetview,
                                  color: grey,
                                  size: 16,
                                )),
                            // controller: model.emailTextController,
                            keyboardType: TextInputType.text,
                          ),
                          UIHelper.verticalSpaceSmall,
                          TextFormField(
                            controller: model.address2,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: white, width: 0.5)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 0.5, color: primaryColor),
                              ),
                              labelText: 'Address Line 2',
                              labelStyle: Theme.of(context).textTheme.bodyText1,
                              isDense: true,
                            ),
                            // controller: model.emailTextController,
                            keyboardType: TextInputType.text,
                          ),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                        City
----------------------------------------------------------------------*/
                          TextFormField(
                              controller: model.city,
                              validator: (value) =>
                                  model.formTextFieldValidation(value),
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: white, width: 0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 0.5, color: primaryColor),
                                  ),
                                  labelText: 'City',
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  isDense: true,
                                  suffixIcon: Icon(
                                    Icons.location_city,
                                    color: grey,
                                    size: 16,
                                  )),
                              // controller: model.emailTextController,
                              keyboardType: TextInputType.text),

/*----------------------------------------------------------------------
                        Row Province and Postal Code
----------------------------------------------------------------------*/
                          UIHelper.verticalSpaceSmall,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                    controller: model.province,
                                    validator: (value) =>
                                        model.formTextFieldValidation(value),
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor: primaryColor,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: white, width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 0.5, color: primaryColor),
                                      ),
                                      labelText: 'Province',
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      isDense: true,
                                    ),
                                    // controller: model.emailTextController,
                                    keyboardType: TextInputType.text),
                              ),
                              UIHelper.horizontalSpaceSmall,
                              /*----------------------------------------------------------------------
                                      Postal Code
                      ----------------------------------------------------------------------*/
                              Expanded(
                                child: TextFormField(
                                    controller: model.postalCode,
                                    validator: (value) =>
                                        model.formTextFieldValidation(value),
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor: primaryColor,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: white, width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 0.5, color: primaryColor),
                                      ),
                                      labelText: 'Postal Code',
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      isDense: true,
                                    ),
                                    // controller: model.emailTextController,
                                    keyboardType: TextInputType.text),
                              ),
                            ],
                          ), // Row province and postal code ends
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                      Country of Residense
 ----------------------------------------------------------------------*/
                          model.isBusy
                              ? model.sharedService.loadingIndicator()
                              : _countryList('residense', model),
                          UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                      Radio Button Accredited Investor
 ----------------------------------------------------------------------*/

                          Row(
                            children: <Widget>[
                              Text('Are you an accredited investor?',
                                  style: Theme.of(context).textTheme.headline6),
                              Checkbox(
                                  activeColor: primaryColor,
                                  value: model.accreditedInvestor,
                                  onChanged: (value) {
                                    model.setBusy(true);
                                    model.accreditedInvestor = value;
                                    print(model.accreditedInvestor);
                                    model.setBusy(false);
                                  }),
                            ],
                          ),
                          Text(
                              'If yes, please provide some documents to help confirm your accredited investor status upon request.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: yellow)),
/*----------------------------------------------------------------------
                      User Photo ID
 ----------------------------------------------------------------------*/
                          UIHelper.verticalSpaceSmall,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: UIHelper.getScreenFullWidth(context),
                                padding: EdgeInsets.all(7.0),
                                color: secondaryColor,
                                child: Text(
                                  'Photo ID',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),

                              // Photo Id picker
                              FlatButton.icon(
                                  onPressed: () {
                                    model.getImage('photoId');
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 16,
                                    color: primaryColorWithAlpha150,
                                  ),
                                  // Image path

                                  label: Expanded(
                                    child: Text(
                                        // model.photoIdFile == null
                                        //   ?
                                        'Choose photo ID\'s',
                                        // : model.photoIdFile.path
                                        //     .split('/')
                                        //     .last
                                        //     .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  )),

                              model.photoIdFile.isEmpty
                                  ? Center(child: Text('No image selected.'))
                                  : Container(
                                      // visible: model.photoIdFile.isNotEmpty,
                                      height:
                                          model.photoIdFile.isEmpty ? 5 : 100,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: model.photoIdFile.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: EdgeInsets.all(2),
                                              child: Stack(
                                                  overflow: Overflow.visible,
                                                  children: [
                                                    Container(
                                                      child: Image.file(
                                                        model
                                                            .photoIdFile[index],
                                                        //  fit: BoxFit.contain,
                                                        //  width: 100,
                                                        //  height: 100,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // alignment:
                                                      //     Alignment.topRight,
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: red,
                                                            size: 16,
                                                          ),
                                                          onPressed: () {
                                                            print('222');
                                                            model.setBusy(true);
                                                            model.photoIdFile
                                                                .removeAt(
                                                                    index);
                                                            model
                                                                .setBusy(false);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            );
                                          }),
                                    ),
                              UIHelper.verticalSpaceSmall,
                              Text(
                                'Upload photos of the front and back of your ID. The size of eatch photo must be less than 500k, Make sure the pictures are clear. Passport, Driver\'s License or Citizenship Card are examples of acceptable ID. Minimum of 2 photos required.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              // Add demo photo
                            ],
                          ),

                          UIHelper.verticalSpaceMedium,
/*----------------------------------------------------------------------
                      User Photo
 ----------------------------------------------------------------------*/
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: UIHelper.getScreenFullWidth(context),
                                padding: EdgeInsets.all(7.0),
                                color: secondaryColor,
                                child: Text(
                                  'Your Photo',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              // Image picker
                              FlatButton.icon(
                                onPressed: () {
                                  model.getImage('personalPhoto');
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 16,
                                  color: primaryColorWithAlpha150,
                                ),
                                // Image path

                                label: Expanded(
                                  child: Text(
                                      // model.personalPhotoFile == null
                                      //    ?
                                      'Choose personal photo',
                                      //     : model.personalPhotoFile.path
                                      //         .split('/')
                                      //         .last
                                      //         .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                ),
                              ),
                              Center(
                                child: model.personalPhotoFile.isEmpty
                                    ? Text('No image selected.')
                                    : Container(
                                        // visible: model.photoIdFile.isNotEmpty,
                                        height: model.personalPhotoFile.isEmpty
                                            ? 5
                                            : 100,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                model.personalPhotoFile.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: EdgeInsets.all(2),
                                                child: Stack(
                                                    overflow: Overflow.visible,
                                                    children: [
                                                      Container(
                                                        child: Image.file(
                                                          model.personalPhotoFile[
                                                              index],
                                                          //  fit: BoxFit.contain,
                                                          //  width: 100,
                                                          //  height: 100,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        // alignment:
                                                        //     Alignment.topRight,
                                                        right: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          child: IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              color: red,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {
                                                              print('222');
                                                              model.setBusy(
                                                                  true);
                                                              model
                                                                  .personalPhotoFile
                                                                  .removeAt(
                                                                      index);
                                                              model.setBusy(
                                                                  false);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              );
                                            }),
                                      ),
                              ),

                              UIHelper.verticalSpaceSmall,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                    '1. Please take a picture you holding one of your IDs; front and back. For your pictures, make sure:',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('2. Your face is clearly visible',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                    '3. The Photo ID is clearly visible',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                    '4. You have a note with today\'s date in the picture',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                    '5. Minimum of 1 photos required; one front.The size must be less than 500k',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              UIHelper.verticalSpaceMedium,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                    'Please verify all information. Once submitted, the information can not be edited',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
/*----------------------------------------------------------------------
                      Submit Button
 ----------------------------------------------------------------------*/
                          UIHelper.verticalSpaceMedium,

                          RaisedButton(
                            splashColor: secondaryColor,
                            elevation: 5,
                            onPressed: () {
                              model.formSubmit();
                            },
                            child: model.isBusy
                                ? Text(AppLocalizations.of(context).loading)
                                : Text(AppLocalizations.of(context).submit),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

/*----------------------------------------------------------------------
                      Country List Dropdown
 ----------------------------------------------------------------------*/
  Widget _countryList(String value, KycViewModel model) {
    return Container(
      color: value == 'residense' ? walletCardColor : secondaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Padding(
                padding: value == 'residense'
                    ? EdgeInsets.symmetric(horizontal: 0, vertical: 2)
                    : EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Text(
                    value == 'residense'
                        ? 'Country of Residense:'
                        : 'Citizenship:',
                    style: Theme.of(context).textTheme.bodyText1),
              )),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: DropdownButtonFormField(
                elevation: 5,
                validator: (value) => model.formTextFieldValidation(value),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconEnabledColor: primaryColor,
                iconSize: 18,
                isDense: true,
                hint: Center(
                  child: Text(
                    model.countryList[0],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                value: value == 'residense'
                    ? model.countryOfResidense
                    : model.citizenship,
                items: model.countryList.map(
                  (country) {
                    //    print(country);
                    return DropdownMenuItem(
                        child: Center(
                          child: Text(country,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        value: country);
                  },
                ).toList(),
                onChanged: (newValue) {
                  model.setBusy(true);
                  if (value == 'residense') {
                    model.countryOfResidense = newValue;
                    print(model.countryOfResidense);
                  } else {
                    model.citizenship = newValue;
                    print(model.citizenship);
                  }
                  model.setBusy(false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
