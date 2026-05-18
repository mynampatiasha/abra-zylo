import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/screens/myDownloadableProducts/bloc/downloadable_product_screen_events.dart';
import 'package:oc_demo/screens/myDownloadableProducts/views/download_product_item_card.dart';

import '../../common_widgets/alert_message.dart';
import '../../models/downloadProductModel/download_product_model.dart';
import 'bloc/downloadable_product_screen_bloc.dart';
import 'bloc/downloadable_product_screen_state.dart';

class MyDownloadableProductsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DownloadableProductsState();
  }
}

class _DownloadableProductsState extends State<MyDownloadableProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? _localizations;
  bool isFromPagination = false;
  bool isLoading = true;
  int page = 1;
  DownloadableProductScreenBloc? _downloadableProductScreenBloc;
  DownloadProductModel? downloadProductModel;
  List<DownloadData> productList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  void initState() {
    super.initState();
    _downloadableProductScreenBloc =
        context.read<DownloadableProductScreenBloc>();
    _downloadableProductScreenBloc
        ?.add(DownloadableProductScreenDataFetchEvent(page.toString()));

    _scrollController.addListener(() {
      paginationFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.myDownloadableProducts) ??
              "",
          context),
      body: BlocBuilder<DownloadableProductScreenBloc,
          DownloadableProductScreenState>(builder: (context, currentState) {
        if (currentState is DownloadableProductScreenInitial) {
          if (!isFromPagination) {
            isLoading = true;
          }
        } else if (currentState is DownloadableProductScreenSuccess) {
          isLoading = false;
          isFromPagination = false;
          downloadProductModel = currentState.returns;
          if (downloadProductModel?.error != 1) {
            if (page == 1) {
              productList = downloadProductModel?.downloadData ?? [];
            } else {
              productList.addAll(downloadProductModel?.downloadData ?? []);
            }
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(
                  downloadProductModel?.message ?? "", context);
            });
          }
        } else if (currentState is DownloadableProductScreenError) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
          });
        }
        return isLoading ? const Loader() : _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        if (downloadProductModel?.error != 1 &&
            (downloadProductModel?.downloadData?.length ?? 0) > 0) ...[
          ListView.builder(
              controller: _scrollController,
              itemCount: productList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return downloadProductItem(
                    context, productList[index], _localizations);
              }),
        ] else ...[
          Center(
            child: Text((downloadProductModel?.message?.isNotEmpty == true)
                ? (downloadProductModel?.message ?? "")
                : _localizations
                        ?.translate(AppStringConstant.noDownloadableProducts) ??
                    "No Downloadable Products"),
          )
        ],
        if (isFromPagination) const Loader()
      ],
    );
  }

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        int.parse((downloadProductModel?.downloadsTotal ?? "0")) !=
            productList.length) {
      setState(() {
        var totalPages =
            (int.parse(downloadProductModel?.downloadsTotal ?? "0") / 20);
        var totalDataCount =
            int.parse(downloadProductModel?.downloadsTotal ?? "0");
        if ((int.parse(downloadProductModel?.downloadsTotal ?? "0") / 5 == 0)) {
          totalPages++;
        }

        if (productList.length < totalDataCount) {
          page++;
          _downloadableProductScreenBloc
              ?.add(DownloadableProductScreenDataFetchEvent(page.toString()));
          isFromPagination = true;
        }
      });
    }
  }
}
