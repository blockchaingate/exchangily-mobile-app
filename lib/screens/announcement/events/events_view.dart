import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/screens/announcement/events/events_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/web_view_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EventsViewModel(),
        onViewModelReady: (EventsViewModel model) async {
          model.init();
        },
        builder: (context, EventsViewModel model, child) {
          return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: Container(
                // constraints: const BoxConstraints(minWidth: 250),
                margin: const EdgeInsets.symmetric(vertical: 60),
                height: 100,
                color: Theme.of(context).canvasColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: model.isAnnouncement
                                  ? primaryColor
                                  : Theme.of(context).canvasColor,
                              textStyle: const TextStyle(
                                  color: white, fontWeight: FontWeight.w400),
                              side: const BorderSide(
                                  color: primaryColor, width: 1)),
                          child: Row(
                            children: [
                              Text(
                                FlutterI18n.translate(context, "announcements"),
                                style: const TextStyle(color: white),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 5.0, bottom: 5.0),
                                child: Icon(
                                  FontAwesomeIcons.bullhorn,
                                  size: 16,
                                  color: white,
                                ),
                              )
                            ],
                          ),
                          onPressed: () => model.updateUrl(
                              exchangilyAnnouncementUrl,
                              isAnnouncement: true),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !model.isAnnouncement
                                  ? primaryColor
                                  : Theme.of(context).canvasColor,
                            ),
                            child: Row(
                              children: [
                                Text(FlutterI18n.translate(context, "blog"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Icon(
                                    FontAwesomeIcons.blog,
                                    size: 16,
                                    color: model.storageService!.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () =>
                                model.updateUrl(exchangilyBlogUrl)),
                      ],
                    ),

                    // website link
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: model.isBusy
                          ? model.sharedService!.loadingIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        model.sharedService!.launchInBrowser(
                                            Uri.parse(model.url));
                                      },
                                    text: FlutterI18n.translate(
                                        context, "visitWebsite"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.web,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                    ),
                    UIHelper.verticalSpaceSmall
                  ],
                ),
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    model.isBusy
                        ? const Text('...')
                        : Expanded(
                            child: WebViewWidget(
                                model.url, 'Exchangily Announcements'),
                          )
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavBar(count: 3));
        });
  }
}
