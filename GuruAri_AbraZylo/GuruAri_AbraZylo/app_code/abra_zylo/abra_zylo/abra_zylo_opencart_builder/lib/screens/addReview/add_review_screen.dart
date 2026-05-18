import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_text_field.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/image_view.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/rating_bar.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import 'bloc/add_review_screen_bloc.dart';
import 'bloc/add_review_screen_event.dart';
import 'bloc/add_review_screen_state.dart';

class AddReviewScreen extends StatefulWidget {
  final String productName;
  final String thumbNail;
  final String templateId;

  const AddReviewScreen(this.productName, this.thumbNail, this.templateId,
      {Key? key})
      : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  AddReviewScreenBloc? _addReviewScreenBloc;
  AppLocalizations? _localizations;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController reviewTitle = TextEditingController();
  TextEditingController reviewDetail = TextEditingController();
  double rating = 0.0;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _addReviewScreenBloc = context.read<AddReviewScreenBloc>();
    AppSharedPref.getLoginUserData().then((value) {
      reviewTitle.text =
          (value?.firstname ?? "") + " " + (value?.lastname ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddReviewScreenBloc, AddReviewScreenState>(
        builder: (context, currentState) {
      if (currentState is AddReviewLoadingState) {
        isLoading = true;
      } else if (currentState is AddReviewSuccessState) {
        isLoading = false;
        if (currentState.data.error == 0) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.pop(context, true);
            AlertMessage.showSuccess(currentState.data.message ?? '', context);
          });
        } else {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.data.message ?? '', context);
          });
        }
      } else if (currentState is AddReviewErrorState) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message, context);
        });
      }
      return _buildUI();
    });
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Scaffold(
          appBar: commonToolBar(
              _localizations?.translate(AppStringConstant.addReviews) ?? "",
              context,
              isElevated: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.thumbNail.isNotEmpty == true) ...[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSizes.size4, 0.0, AppSizes.size16, 0.0),
                            child: SizedBox(
                                height: AppSizes.deviceHeight / 5,
                                width: AppSizes.deviceWidth / 4,
                                child: ImageView(url: widget.thumbNail))),
                      ],
                      Expanded(
                          child: Text(widget.productName,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.displaySmall))
                    ],
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  Text(
                      _localizations?.translate(AppStringConstant.rating) ?? "",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  RatingBarCustom(
                    starCount: 5,
                    color: AppColors.yellow,
                    rating: rating,
                    onRatingChanged: (_rating) {
                      rating = _rating;
                    },
                  ),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CommonTextField(
                        controller: reviewTitle,
                        isPassword: false,
                        hintText: _localizations
                                ?.translate(AppStringConstant.yourName) ??
                            "",
                        isRequired: true,
                      ),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      CommonTextField(
                          controller: reviewDetail,
                          isPassword: false,
                          maxLine: null,
                          hintText: _localizations?.translate(
                                  AppStringConstant.Writeyourreview) ??
                              "",
                          isRequired: true),
                    ]),
                  ),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  Container(
                    width: AppSizes.deviceWidth,
                    child: ElevatedButton(
                        // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).textTheme.headlineMedium?.color),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState!.validate() &&
                              rating != 0.0) {
                            _addReviewScreenBloc?.add(
                              AddReviewSaveEvent(
                                  reviewTitle.text,
                                  rating.toString(),
                                  reviewDetail.text,
                                  widget.templateId),
                            );
                          } else if (rating == 0.0) {
                            AlertMessage.showError(
                                _localizations?.translate(
                                        AppStringConstant.selectRating) ??
                                    "",
                                context);
                          }
                        },
                        child: Text(
                          (_localizations
                                      ?.translate(AppStringConstant.submit) ??
                                  "")
                              .toUpperCase(),
                          // style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).cardColor),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(visible: isLoading, child: Loader())
      ],
    );
  }
}
