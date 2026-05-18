import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsLetter_screen_state.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsletter_screen_bloc.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsletter_screen_event.dart';

import '../../common_widgets/alert_message.dart';
import '../login_signup/view/signup_extra_views.dart';

class NewsletterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsletterScreenState();
  }
}

class NewsletterScreenState extends State<NewsletterScreen> {
  String isNewsletter = "";
  bool isLoading = false;
  NewsLetterScreenBloc? _bloc;

  @override
  void initState() {
    /*  AppSharedPref.getLoginUserData().then((value) {
      if (value?.newsletter == "1") {
        isNewsletter = "1";
      }
    });*/
    _bloc = context.read<NewsLetterScreenBloc>();
    _bloc?.add(GetNewsLetterEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsLetterScreenBloc, NewsLetterScreenState>(
        builder: (context, currentState) {
      if (currentState is NewsLetterScreenInitial) {
        isLoading = true;
      } else if (currentState is GetNewsLetterSuccess) {
        isLoading = false;
        isNewsletter = currentState?.baseModel.newsletter;
      } else if (currentState is NewsLetterScreenSuccess) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              currentState.baseModel.message ?? "", context);
          Navigator.pop(context);
        });
      } else if (currentState is NewsLetterScreenError) {
        isLoading = false;

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message ?? "", context);
        });
      }
      return newsLetterView();
    });
  }

  Widget newsLetterView() {
    AppLocalizations? localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: commonAppBar(
          localizations?.translate(AppStringConstant.newsLetter) ?? "",
          context),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.size10),
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.size10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations?.translate(
                                    AppStringConstant.newsLetterSubscription) ??
                                "",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          /*const SizedBox(
                            height: 20,
                          ),*/
                          Newsletter(
                            (value) {
                              isNewsletter = value;
                            },
                            "",
                            selectedId: isNewsletter,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(visible: isLoading, child: Loader()),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.size10, horizontal: AppSizes.size10),
              child: ElevatedButton(
                onPressed: () {
                  _bloc?.add(SetNewsLetterEvent(isNewsletter));
                  _bloc?.emit(NewsLetterScreenInitial());
                  //  handleAPI();
                },
                style: OutlinedButton.styleFrom(
                  fixedSize:
                      Size(AppSizes.deviceWidth, AppSizes.deviceWidth / 8),
                  side: const BorderSide(
                      width: AppSizes.size1,
                      // color: Theme.of(context).buttonColor,
                      style: BorderStyle.solid),
                  // shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(4))),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    AppStringConstant.continueAsGuest.localized().toUpperCase(),
                    // style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleAPI() async {
    setState(() {
      isLoading = true;
    });
    var baseModel = await ApiClient()
        .subscribeNewsletter(await AppSharedPref.getWkToken(), isNewsletter);
    isLoading = false;
    if (baseModel.error == 0) {
      AlertMessage.showSuccess(baseModel.message ?? "", context);
      Navigator.of(context).pop();
      var loginModel = await AppSharedPref.getLoginUserData();
      loginModel?.newsletter = isNewsletter;
      AppSharedPref.setLoginUserData(loginModel!);
    } else {
      AlertMessage.showError(baseModel.message ?? "", context);
    }
  }
}
