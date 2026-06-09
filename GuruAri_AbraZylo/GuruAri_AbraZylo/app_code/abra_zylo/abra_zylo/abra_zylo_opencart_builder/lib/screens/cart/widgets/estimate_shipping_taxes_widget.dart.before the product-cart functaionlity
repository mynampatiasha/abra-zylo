import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';

import '../../../../common_widgets/common_outlined_button.dart';
import '../../../../common_widgets/common_text_field.dart';
import '../../../../common_widgets/common_tool_bar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../common_widgets/alert_message.dart';

class EstimateShippingAndTaxesWidget extends StatefulWidget {
  final CountryDataModel countryDataModel;
  final CartScreenBloc bloc;

  const EstimateShippingAndTaxesWidget(this.countryDataModel, this.bloc,
      {Key? key})
      : super(key: key);

  @override
  _EstimateShippingAndTaxesWidgetState createState() =>
      _EstimateShippingAndTaxesWidgetState();
}

class _EstimateShippingAndTaxesWidgetState
    extends State<EstimateShippingAndTaxesWidget> {
  AppLocalizations? _localizations;
  bool isLoading = false;
  String selectedCountry = "";
  String selectedState = "";
  String? countryId, stateId;
  List<Zone>? zoneList;

  TextEditingController postCodeTextContoller = TextEditingController();

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    selectedCountry =
        _localizations?.translate(AppStringConstant.selectCountry) ?? "";
    selectedState =
        _localizations?.translate(AppStringConstant.selectState) ?? "";
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildUI());
  }

  Widget _buildUI() {
    return Container(
      height: AppSizes.deviceHeight / 1.9,
      child: Stack(
        children: [
          Scaffold(
            appBar: commonToolBar(
                _localizations
                        ?.translate(AppStringConstant.estimateShippingTax) ??
                    "",
                context,
                isElevated: true),
            body: Container(
              color: Theme.of(context).cardColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: AppSizes.size8,
                      bottom: AppSizes.size8,
                      left: AppSizes.size16,
                      right: AppSizes.size16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: AppSizes.size6,
                      ),
                      /*
                      * Country drop down
                      * */
                      Text(
                        _localizations
                                ?.translate(AppStringConstant.selectCountry) ??
                            "",
                        style: TextStyle(color: AppColors.darkGray),
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: formFieldDecoration(context, "", "",
                              isRequired: true),
                          items: widget.countryDataModel.countryData
                              ?.map((CountryData value) {
                            String countryName = value.name ?? "";
                            return DropdownMenuItem(
                              child: Text(
                                countryName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.darkGray),
                              ),
                              value: value.countryId,
                            );
                          }).toList(),
                          hint: Text(
                            selectedCountry,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.darkGray),
                          ),
                          onChanged: (newValue) async {
                            widget.countryDataModel.countryData
                                ?.forEach((element) {
                              if (newValue == element.countryId) {
                                setState(() {
                                  zoneList = element.zone;
                                  selectedCountry = element.name ?? "";
                                  countryId = element.countryId;
                                });
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      /*
                      * State Drop Down
                      * */
                      Text(
                        _localizations
                                ?.translate(AppStringConstant.selectState) ??
                            "",
                        style: TextStyle(color: AppColors.darkGray),
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: formFieldDecoration(context, "", "",
                              isRequired: true),
                          items: zoneList?.map((Zone value) {
                            String optionString = value.name ?? "";
                            return DropdownMenuItem(
                              child: Text(optionString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.darkGray)),
                              value: value.zoneId,
                            );
                          }).toList(),
                          // isExpanded: true,
                          hint: Text(
                            selectedState,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.darkGray),
                          ),

                          onChanged: (newValue) async {
                            zoneList?.forEach((element) {
                              if (newValue == element.zoneId) {
                                setState(() {
                                  selectedState = element.name ?? "";
                                  stateId = element.zoneId;
                                });
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      /* Text(
                        _localizations
                                ?.translate(AppStringConstant.postCode) ??
                            "",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.darkGray),
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),*/
                      // CommonTextField(
                      //     labelText: _localizations
                      //             ?.translate(AppStringConstant.postCode) ??
                      //         "",
                      //     controller: postCodeTextContoller,
                      //     isPassword: false,
                      //     hintText: _localizations?.translate(
                      //             AppStringConstant.enterPostCode) ??
                      //         "",
                      //     maxLine: 1,
                      //     isRequired: true),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      commonButton(
                        context,
                        () {
                          if ((countryId?.isNotEmpty ?? false)) {
                            widget.bloc.add(GetShippingMethodEvent(
                                countryId ?? "",
                                stateId ?? "0",
                                postCodeTextContoller.text));
                            widget.bloc.emit(CartScreenStateInitial());
                          } else {
                            AlertMessage.showError(
                                _localizations?.translate(AppStringConstant
                                        .pleaseSelectCountryOrState) ??
                                    "",
                                context);
                          }
                        },
                        (_localizations?.translate(AppStringConstant.submit) ??
                                "")
                            .toUpperCase(),

                        // textColor: Colors.white),
                        // backgroundColor:
                        //     Theme.of(context).colorScheme.onPrimary,
                        // textColor: AppColors.white
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(visible: isLoading, child: Loader())
        ],
      ),
    );
  }
}
