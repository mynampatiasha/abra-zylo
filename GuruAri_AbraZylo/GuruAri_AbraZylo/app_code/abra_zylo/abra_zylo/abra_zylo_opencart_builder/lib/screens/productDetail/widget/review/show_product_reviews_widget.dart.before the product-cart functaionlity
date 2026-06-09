import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/widget/review/product_review_circle.dart';
import 'package:oc_demo/screens/productDetail/widget/review/review_list_item_card.dart';

import '../../../../common_widgets/alert_message.dart';
import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/dialog_helper.dart';
import '../../../../common_widgets/loader.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/arguments_map.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../../helper/generic_methods.dart';
import '../../../../helper/open_bottom_model_sheet_helper.dart';
import '../../Bloc/review_screen_bloc.dart';
import '../../Bloc/review_screen_state.dart';

class ShowProductReviewWidget extends StatefulWidget {
  String? productName;
  Map<String, dynamic>? arguments;

  ShowProductReviewWidget(this.arguments, {Key? key}) : super(key: key);

  @override
  _ShowProductReviewWidgetState createState() =>
      _ShowProductReviewWidgetState();
}

class _ShowProductReviewWidgetState extends State<ShowProductReviewWidget> {
  ReviewScreenBloc? reviewPageBloc;
  bool isLoading = false;
  ReviewData? reviewsData;
  bool isFromReview = false;
  ProductDetailScreenModel? model;
  ProductDetailBloc? productPageBloc;
  AppLocalizations? _localizations;

  @override
  void initState() {
    model = widget.arguments?[productData];
    productPageBloc = widget.arguments?[productBloc];

    reviewPageBloc = context.read<ReviewScreenBloc>();
    reviewPageBloc
        ?.add(GetProductReviewEvent(model?.productId?.toString() ?? "0", "1"));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.reviews) ?? "", context),
      body: BlocBuilder<ReviewScreenBloc, ReviewScreenState>(
        builder: (context, currentState) {
          if (currentState is ReviewScreenInitial) {
            reviewsData = null;
            if (!isFromReview) {
              isLoading = true;
            }
          } else if (currentState is GetProductReviewStateSuccess) {
            reviewsData = currentState.reviewData;
            isLoading = false;
          } else if (currentState is ReviewScreenError) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
            });
          }
          return buildProductReviewUI();
        },
      ),
    );
  }

  Widget buildProductReviewUI() {
    return isLoading
        ? Loader()
        : (reviewsData?.reviews == null || reviewsData?.reviews?.length == 0)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      GenericMethods.getStringValue(
                          context, AppStringConstant.beFirstOneToReview),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.apply(color: AppColors.red),
                    ),
                    const SizedBox(
                      height: AppSizes.size8,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: AppSizes.size8),
                      child: GestureDetector(
                        onTap: () {
                          //  addReviewBottomSheet(context,widget.productName??"",widget.thumbnail??"", widget.productId??0);
                        },
                        child: Text(
                            GenericMethods.getStringValue(
                                context, AppStringConstant.addReview),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: AppColors.black, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: Theme.of(context).cardColor,
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSizes.size16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const ProductReviewCircle(),
                          productRating()
                        ],
                      ),
                    ),
                    productReviewList(reviewsData?.reviews)
                  ]),
                ),
              );
  }

  Widget productReviewList(List<Reviews>? productReviews) {
    return ((productReviews != null)
        ? Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSizes.size4, horizontal: AppSizes.size4),
            child: ListView.builder(
                itemCount: productReviews.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = productReviews[index];
                  return reviewListItemCard(
                    data,
                    context,
                  );
                }),
          )
        : Container());
  }

  Widget productRating() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     RatingContainer(3.0),
      //   ],
      // ),
      Container(
        padding: const EdgeInsets.only(top: AppSizes.size20),
        child: Text(
            GenericMethods.getStringValue(context, AppStringConstant.basedOn),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Color(0xFF575454), fontWeight: FontWeight.w400)),
      ),
      Container(
        padding: const EdgeInsets.only(top: AppSizes.size6),
        child: Text(
            '${reviewsData?.reviews?.length} ${GenericMethods.getStringValue(context, AppStringConstant.reviews)}',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
      ),
      Container(
        padding: const EdgeInsets.only(top: AppSizes.size12),
        child: GestureDetector(
          onTap: () async {
            // addReviewBottomSheet(context,widget.productName??"",widget.thumbnail??"", widget.productId??0);
            if (await AppSharedPref.isLogin() == true ||
                (model?.reviewGuest == true)) {
              reviewBottomModalSheet(context, model?.name ?? '',
                  model?.thumb ?? '', model?.productId.toString() ?? "");
            } else {
              DialogHelper.confirmationDialog(
                  "${_localizations?.translate(AppStringConstant.signInToContinue)}",
                  context,
                  _localizations, onConfirm: () async {
                //    Navigator.pushNamed(context, loginSignup,arguments: false);
              });
            }
          },
          child: Text(
              GenericMethods.getStringValue(
                  context, AppStringConstant.addReview),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.blue, fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }
}
