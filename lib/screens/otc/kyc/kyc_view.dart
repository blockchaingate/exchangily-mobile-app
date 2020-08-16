import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/otc/kyc/kyc_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class KycView extends StatelessWidget {
  KycView({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KycViewModel>.reactive(
      viewModelBuilder: () => KycViewModel(),
      onModelReady: (model) {
        model.context = context;
      },
      builder: (context, model, _) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('KYC'),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              print('1111');
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: walletCardColor, blurRadius: 10, spreadRadius: 5),
              ]),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              margin:
                  EdgeInsets.only(right: 15.0, bottom: 10, left: 0, top: 20),
              //  color: walletCardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
/*----------------------------------------------------------------------
                      Header
----------------------------------------------------------------------*/
                  // Container(
                  //   padding: EdgeInsets.all(2),
                  //   decoration: BoxDecoration(
                  //       border: Border(
                  //           bottom: BorderSide(color: primaryColor, width: 3.0))),
                  //   child: Center(
                  //     child: Text(
                  //       'KYC',
                  //       style: Theme.of(context).textTheme.headline2,
                  //     ),
                  //   ),
                  // ),

/*----------------------------------------------------------------------
                      Full Name
----------------------------------------------------------------------*/
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white, width: 0.5)),
                        // border: OutlineInputBorder(
                        //     borderSide: BorderSide(color: white)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 0.5, color: primaryColor),
                        ),
                        labelText: 'Full Name',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
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
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 0.5, color: primaryColor),
                        ),
                        labelText: AppLocalizations.of(context).email,
                        labelStyle: Theme.of(context).textTheme.bodyText1,
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
                  TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 0.5, color: primaryColor),
                        ),
                        labelText: 'Citizenship',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        isDense: true,
                      ),
                      // controller: model.emailTextController,
                      keyboardType: TextInputType.text),
                  UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                    Date of Birth
 ----------------------------------------------------------------------*/
                  TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 0.5, color: primaryColor),
                          ),
                          helperText: 'You should be 19 years or older',
                          helperStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: yellow),
                          labelText: 'MM/DD/YYYY',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          isDense: true,
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: grey,
                            size: 16,
                          )),
                      // controller: model.emailTextController,
                      keyboardType: TextInputType.text),
                  UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                      Address
----------------------------------------------------------------------*/
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 0.5, color: primaryColor),
                        ),
                        labelText: 'Address Line 1',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        hintText: 'Street Address',
                        hintStyle: Theme.of(context).textTheme.bodyText1,
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
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: white, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
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
                  TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 0.5, color: primaryColor),
                          ),
                          labelText: 'City',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
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
                        child: TextField(
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
                              labelText: 'Province',
                              labelStyle: Theme.of(context).textTheme.bodyText1,
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
                        child: TextField(
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
                              labelText: 'Postal Code',
                              labelStyle: Theme.of(context).textTheme.bodyText1,
                              isDense: true,
                            ),
                            // controller: model.emailTextController,
                            keyboardType: TextInputType.text),
                      ),
                    ],
                  ), // Row province and postal code ends
                  UIHelper.verticalSpaceSmall,

/*----------------------------------------------------------------------
                   Country of Residense // Change it to dropdown
 ----------------------------------------------------------------------*/
                  TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 0.5, color: primaryColor),
                        ),
                        labelText: 'Country of Residense',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        isDense: true,
                      ),
                      // controller: model.emailTextController,
                      keyboardType: TextInputType.text),
                  UIHelper.verticalSpaceMedium,
/*----------------------------------------------------------------------
                   User Photo ID
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
                          'Photo ID',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      // Add file manager to select photo
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
                  Theme(
                    data: ThemeData(
                        textSelectionColor: white,
                        textTheme:
                            TextTheme(bodyText2: TextStyle(color: white))),
                    child: Column(
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
                            onPressed: model.getImage,
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 16,
                              color: primaryColorWithAlpha150,
                            ),
                            label: Text('Select Image',
                                style: Theme.of(context).textTheme.bodyText1)),
                        UIHelper.verticalSpaceSmall,
                        Text(
                            '1. Please take a picture you holding one of your IDs; front and back. For your pictures, make sure:'),
                        Text('2. Your face is clearly visible'),
                        Text('3. The Photo ID is clearly visible'),
                        Text(
                            '4. You have a note with today\'s date in the picture'),
                        Text(
                            '5. Minimum of 1 photos required; one front.The size must be less than 500k'),
                        Text(
                            'Please verify all information. Once submitted, the information can not be edited')
                      ],
                    ),
                  ),
/*----------------------------------------------------------------------
                    Submit Button
 ----------------------------------------------------------------------*/
                  UIHelper.verticalSpaceMedium,

                  RaisedButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context).submit),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
