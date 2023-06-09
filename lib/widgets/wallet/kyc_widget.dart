import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/wallet/local_kyc_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:kyc/kyc.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

class KycWidget extends ViewModelWidget<SettingsViewModel> {
  const KycWidget({Key? key}) : super(key: key);

  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();
  @override
  Widget build(BuildContext context, SettingsViewModel model) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5,
              child: InkWell(
                onTap: () async {
                  bool wasDarkMode = model.themeService.isDarkMode;

                  if (model.kycStarted) {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 230,
                              decoration: roundedBoxDecoration(
                                  color: wasDarkMode ? secondaryColor : grey),
                              child: Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        UIHelper.verticalSpaceLarge,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              FlutterI18n.translate(
                                                  context, "status"),
                                              style: headText3,
                                            ),
                                            UIHelper.horizontalSpaceMedium,
                                            Text(
                                              model.kycCheckResult.kyc!.status
                                                          .toString() ==
                                                      '0'
                                                  ? FlutterI18n.translate(
                                                      context, "kycStarted")
                                                  : FlutterI18n.translate(
                                                      context, "kycApproved"),
                                              style: headText4,
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceMedium,
                                        UIHelper.divider,
                                        UIHelper.verticalSpaceMedium,
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  FlutterI18n.translate(
                                                      context, "step"),
                                                  style: headText3,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    model.kycCheckResult.kyc!
                                                                .step ==
                                                            -1
                                                        ? '0'
                                                        : model.kycCheckResult
                                                            .kyc!.step
                                                            .toString(),
                                                    style: headText3,
                                                  ),
                                                ),
                                                UIHelper.horizontalSpaceMedium,
                                                Text(
                                                  FlutterI18n.translate(context,
                                                      'kycStep${model.kycCheckResult.kyc!.step.toString()}'),
                                                  style: headText4,
                                                ),
                                              ],
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                            model.kycCheckResult.kyc!.step == 7
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        roundedBoxDecoration(
                                                            color:
                                                                primaryColor),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "waitingForApproval"),
                                                        style:
                                                            headText5.copyWith(
                                                                color: white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : TextButton(
                                                    onPressed: () async {
                                                      if (wasDarkMode) {
                                                        model.themeService
                                                            .toggleDarkLightTheme();
                                                      }
                                                      model.setBusy(true);

                                                      try {
                                                        final kycService =
                                                            locator<
                                                                KycBaseService>();
                                                        final kycNavigationService =
                                                            locator<
                                                                KycNavigationService>();

                                                        var data =
                                                            'action=login';

                                                        var sig =
                                                            await LocalKycUtil
                                                                .signKycData(
                                                                    data,
                                                                    context);

                                                        String url = isProduction
                                                            ? KycConstants
                                                                .prodBaseUrl
                                                            : KycConstants
                                                                .testBaseUrl;

                                                        Map<String, dynamic>
                                                            res = {};
                                                        if (sig.isNotEmpty) {
                                                          res = await kycService
                                                              .login(url, sig);
                                                          debugPrint(
                                                              'login res $res');
                                                          model.setBusy(false);
                                                          if (res['success']) {
                                                            var token =
                                                                res['data']
                                                                        ['data']
                                                                    ['token'];

                                                            kycService
                                                                .updateXAccessToken(
                                                                    token);

                                                            kycNavigationService
                                                                .navigateToStep(
                                                                    context,
                                                                    model
                                                                        .kycCheckResult
                                                                        .kyc!
                                                                        .step);
                                                          } else {
                                                            model
                                                                .setBusy(false);
                                                            model.sharedService
                                                                .sharedSimpleNotification(
                                                                    FlutterI18n.translate(
                                                                        context,
                                                                        'loginFailed'),
                                                                    isError:
                                                                        true);
                                                          }
                                                        } else {
                                                          model.setBusy(false);
                                                          res = {
                                                            'success': false,
                                                            'error':
                                                                'Failed to sign data'
                                                          };
                                                        }
                                                      } catch (e) {
                                                        debugPrint(
                                                            'CATCH error $e');
                                                        model.setBusy(false);
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          FlutterI18n.translate(
                                                              context,
                                                              "continue"),
                                                          style:
                                                              const TextStyle(
                                                                  letterSpacing:
                                                                      1.1),
                                                        ),
                                                        UIHelper
                                                            .horizontalSpaceSmall,
                                                        const Icon(
                                                          Icons
                                                              .double_arrow_rounded,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  if (model.isBusy)
                                    Center(
                                      child: Container(
                                        decoration: roundedBoxDecoration(
                                            color: black.withOpacity(0.5)),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    if (wasDarkMode) {
                      model.themeService.toggleDarkLightTheme();
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KycView(
                          kycPrimaryColor: primaryColor,
                          onFormSubmit: (KycModel kycModel) async {
                            try {
                              final kycService = locator<KycBaseService>();
                              var data =
                                  'email=${kycModel.email}&first_name=${kycModel.firstName}&last_name=${kycModel.lastName}';

                              var sig =
                                  await LocalKycUtil.signKycData(data, context);

                              String url = isProduction
                                  ? KycConstants.prodBaseUrl
                                  : KycConstants.testBaseUrl;
                              final Map<String, dynamic> res;

                              if (sig.isNotEmpty) {
                                res = await kycService.submitKycData(
                                    url, kycModel.setSignature(sig));
                              } else {
                                res = {
                                  'success': false,
                                  'error': 'Failed to sign data'
                                };
                              }
                              return res;
                            } catch (e) {
                              debugPrint('CATCH error $e');
                            }
                          },
                          // ),
                        ),
                      ),
                    );
                  }
                  if (model.storageService.isDarkMode) {
                    model.themeService.setThemeMode(ThemeManagerMode.dark);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withAlpha(900),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user,
                          color: Colors.white), // Icon related to KYC
                      const SizedBox(width: 8.0), // Space between icon and text
                      model.busy(model.kycStarted)
                          ? Text(
                              FlutterI18n.translate(context, "loading"),
                              style: headText5,
                            )
                          : Text(
                              FlutterI18n.translate(
                                  context,
                                  model.kycStarted
                                      ? FlutterI18n.translate(
                                          context, "checkKycStatus")
                                      : FlutterI18n.translate(
                                          context, "startKycProcess")),
                              style: headText5.copyWith(color: Colors.white),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          )
          // ),
        ],
      ),
    );
  }
}
