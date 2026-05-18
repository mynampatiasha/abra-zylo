import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/common_tableview.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/transactionModel/transaction_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

class TransactionInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionInfoState();
  }
}

class _TransactionInfoState extends State<TransactionInfoScreen> {
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  bool isLoading = true;
  String errorMessage = "";
  TransactionModel? transactionData;

  @override
  Widget build(BuildContext context) {
    /* List<String> heading = [
      _localizations?.translate(AppStringConstant.dateAdded) ?? "Date Added",
      _localizations?.translate(AppStringConstant.description) ?? "Description",
      _localizations?.translate(AppStringConstant.amount) ?? "Amount"
    ];
    List<List<String>> dataList = [];
    if (transactionData != null) {
      for (TransactionData data in transactionData?.transactionData ?? []) {
        dataList.add(
            [data.dateAdded ?? "", data.description ?? "", data.amount ?? ""]);
      }
    }*/
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.yourTransactions) ?? "",
          context),
      body: isLoading
          ? const Loader()
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: TextStyle(
                          color: SchedulerBinding
                                      .instance!.window.platformBrightness ==
                                  Brightness.dark
                              ? AppColors.white
                              : AppColors.black,
                          fontSize: 16)),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.size20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Html(
                            data: transactionData?.transactionText,
                            style: {
                              'html': Style(
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w700),
                            },
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.size6,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: transactionData?.transactionData?.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: AppColors.darkGray,
                                    width: 1,
                                  )),
                                  child: tableTiles(
                                      transactionData?.transactionData?[i]),
                                ),
                              );
                            }),
                        /* Container(
                          margin: const EdgeInsets.symmetric(horizontal: AppSizes.size4),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black)),
                            child: CommonTable(dataList, heading))*/
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget tableTiles(TransactionData? transactionData) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSizes.deviceWidth / 5,
          child: CircleAvatar(
            backgroundColor: AppColors.black,
            child: Icon(Icons.card_giftcard,
                color: SchedulerBinding.instance!.window.platformBrightness ==
                        Brightness.dark
                    ? AppColors.white
                    : AppColors.black),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: AppSizes.size12,
                    bottom: AppSizes.size4,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  transactionData?.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headlineSmall,
                  softWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: AppSizes.size4,
                    bottom: AppSizes.size12,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  transactionData?.dateAdded ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                      color: SchedulerBinding
                                  .instance!.window.platformBrightness ==
                              Brightness.dark
                          ? AppColors.white
                          : AppColors.gray),
                  softWrap: true,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: AppSizes.deviceWidth / 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.size12,
                    bottom: AppSizes.size4,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  transactionData?.amount ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.size4,
                    bottom: AppSizes.size12,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  AppLocalizations.of(context)
                          ?.translate(AppStringConstant.amount) ??
                      " ",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.gray,
                  ),
                  softWrap: true,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void getTransactions() async {
    var model = await ApiClient()
        .getTransactionDetails(await AppSharedPref.getWkToken(), "1");
    if (model.error == 0) {
      transactionData = model;
    } else {
      errorMessage = model.message ?? "No Transactions";
    }
    setState(() {
      isLoading = false;
    });
  }
}
