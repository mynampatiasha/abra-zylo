/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/screens/reviews/views/reviews_main_view.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/lottie_animation.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../models/reviewListModel/reviews_list_model.dart';
import 'block/reviews_screen_bloc.dart';
import 'block/reviews_screen_events.dart';
import 'block/reviews_screen_state.dart';

class ReviewsScreen extends StatefulWidget {
  ReviewsScreen(this.isFromDashboard, {Key? key}) : super(key: key);
  bool isFromDashboard = false;

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  ReviewsScreenBloc? _ReviewsScreenBloc;
  bool isFromPagination = false;
  ReviewsListModel? reviewsListModel;
  List<ReviewsListData> recentReviews = [];
  int page = 1;
  late AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ReviewsScreenBloc = context.read<ReviewsScreenBloc>();
    _ReviewsScreenBloc?.add(ReviewsScreenDataFetchEvent(page));
    _scrollController.addListener(() {
      if (!widget.isFromDashboard) paginationFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isFromDashboard)
          ? null
          : commonAppBar(
              (_localizations?.translate(AppStringConstant.allReviews) ?? "")
                  .toUpperCase(),
              context),
      body: BlocBuilder<ReviewsScreenBloc, ReviewsScreenState>(
          builder: (context, currentState) {
        if (currentState is ReviewsScreenInitial) {
          if (!isFromPagination) {
            isLoading = true;
          }
        } else if (currentState is ReviewsScreenSuccess) {
          isLoading = false;
          isFromPagination = false;
          reviewsListModel = currentState.reviews;
          if (page == 1) {
            recentReviews = reviewsListModel?.reviewsList ?? [];
          } else {
            recentReviews.addAll(reviewsListModel?.reviewsList ?? []);
          }
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            if (currentState.reviews?.success == 1) {
              AlertMessage.showSuccess(
                  _localizations?.translate(
                          AppStringConstant.reviewsFetchedSuccessfully) ??
                      "",
                  context);
            }
          });
        } else if (currentState is ReviewsScreenError) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
          });
        }
        return _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        if (recentReviews.isNotEmpty)
          reviewMainView(context, recentReviews, AppLocalizations.of(context),
              _scrollController,
              scrollPhysics: widget.isFromDashboard
                  ? const AlwaysScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics()),
        Visibility(
          visible: (recentReviews.isEmpty && (!isLoading)),
          child: Center(
            child: LottieAnimation(
                lottiePath: AppImages.emptyOrderLottie,
                title:
                    _localizations?.translate(AppStringConstant.noReview) ?? "",
                subtitle: "",
                buttonTitle: _localizations
                        ?.translate(AppStringConstant.continueShopping) ??
                    "",
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.bottomTabBAr, (route) => false);
                }),
          ),
        ),
        Visibility(visible: isLoading, child: const Loader())
      ],
    );
  }

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        (reviewsListModel?.total ?? 0) != recentReviews.length) {
      setState(() {
        var totalPages = (reviewsListModel?.total ?? 10) / 10;
        if (page < totalPages) {
          page++;
          if (!(widget.isFromDashboard)) {
            _ReviewsScreenBloc?.add(ReviewsScreenDataFetchEvent(page));
          }
          isFromPagination = true;
        }
      });
    }
  }
}
