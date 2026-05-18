import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/common_tableview.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/rewardModel/reward_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

class RewardInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RewardInfoState();
  }
}

class _RewardInfoState extends State<RewardInfoScreen> {
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();
    getRewardPoints();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  bool isLoading = true;
  String errorMessage = "";
  RewardModel? rewardData;

  @override
  Widget build(BuildContext context) {
    List<String> heading = [
      _localizations?.translate(AppStringConstant.dateAdded) ?? "Date Added",
      _localizations?.translate(AppStringConstant.description) ?? "Description",
      _localizations?.translate(AppStringConstant.points) ?? "Points"
    ];
    List<List<String>> dataList = [];
    if (rewardData != null) {
      for (RewardData data in rewardData?.rewardData ?? []) {
        dataList.add(
            [data.dateAdded ?? "", data.description ?? "", data.points ?? ""]);
      }
    }
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.yourRewardPoints) ?? "",
          context),
      body: isLoading
          ? Loader()
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.size20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          rewardData?.rewardText ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size6,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: rewardData?.rewardData?.length,
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
                                child: tableTiles(rewardData?.rewardData?[i]),
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
    );
  }

  Widget tableTiles(RewardData? data) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSizes.deviceWidth / 5,
          child: const CircleAvatar(
            backgroundColor: AppColors.black,
            child: Icon(
              Icons.card_giftcard,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.size12,
                    bottom: AppSizes.size4,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  data?.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headlineSmall,
                  softWrap: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.size4,
                    bottom: AppSizes.size12,
                    left: AppSizes.size4,
                    right: AppSizes.size4),
                child: Text(
                  data?.dateAdded ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
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
                  data?.points ?? "",
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
                          ?.translate(AppStringConstant.points) ??
                      " ",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
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

  void getRewardPoints() async {
    var model = await ApiClient()
        .getRewardPointsDetails(await AppSharedPref.getWkToken(), "1");
    if (model.error == 0) {
      rewardData = model;
    } else {
      errorMessage = model.message ?? "No reward points";
    }
    setState(() {
      isLoading = false;
    });
  }
}
