import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class KycView extends StatelessWidget {
  KycView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            margin: EdgeInsets.only(right: 15.0, bottom: 10, left: 0, top: 20),
            //  color: walletCardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,

/*----------------------------------------------------------------------
                      Header
----------------------------------------------------------------------*/
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: primaryColor, width: 3.0))),
                  child: Center(
                    child: Text(
                      'KYC',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                UIHelper.verticalSpaceLarge,

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
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
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
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
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
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
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
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
                      ),
                      helperText: 'You should be 19 years or older',
                      helperStyle: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: yellow),
                      labelText: 'MM/DD/YYYY',
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      isDense: true,
                    ),
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
                        borderSide: BorderSide(width: 0.5, color: primaryColor),
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
                // Expanded(
                //   child: TextField(
                //       textAlignVertical: TextAlignVertical.center,
                //       cursorColor: primaryColor,
                //       decoration: InputDecoration(
                //         enabledBorder: UnderlineInputBorder(
                //             borderSide: BorderSide(color: white, width: 0.5)),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(4)),
                //           borderSide:
                //               BorderSide(width: 0.5, color: primaryColor),
                //         ),
                //         labelText: 'Country of Residense',
                //         labelStyle: Theme.of(context).textTheme.bodyText1,
                //         isDense: true,
                //       ),
                //       // controller: model.emailTextController,
                //       keyboardType: TextInputType.text),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
