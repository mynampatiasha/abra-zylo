import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:location/location.dart' as locationReq;
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/address/country_datum.dart';
import 'package:oc_demo/models/address/edit_address_book.dart';
import 'package:oc_demo/models/address/zone.dart';
import 'package:oc_demo/screens/login_signup/view/signup_extra_views.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../helper/generic_methods.dart';

class AddressForm extends StatefulWidget {
  const AddressForm(this.model, this.onSaveAddress, this.selectedLanguage,
      {Key? key})
      : super(key: key);
  final EditAddressBook? model;
  final Function(AddAddressRequest) onSaveAddress;
  final String? selectedLanguage;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  AppLocalizations? _localizations;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _firstName,
      _lastName,
      _company,
      _address1,
      _address2,
      _city,
      _zip;
  late String? _selectedCountry,
      _selectedZone,
      _selectedCountryName,
      _selectedZoneName,
      _default;

  CountryDatum? filterCountry;

  @override
  void initState() {
    _formKey = GlobalKey();
    _firstName = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
    _company = TextEditingController(text: "");
    _address1 = TextEditingController(text: "");
    _address2 = TextEditingController(text: "");
    _city = TextEditingController(text: "");
    _zip = TextEditingController(text: "");
    _selectedCountryName = "";
    _selectedZoneName = "";
    // For United Kingdom
    _selectedCountry = "222";
    _default = "0";

    _prepareTextFields();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  void _prepareTextFields() {
    if (widget.model?.data == null) {
      AppSharedPref.getLoginUserData().then((value) {
        _firstName.text = value?.firstname ?? "";
        _lastName.text = value?.lastname ?? "";
      });
      var country = widget.model?.getCountryById(_selectedCountry);
      if (country != null) {
        _selectedCountry = country.countryId;
        _selectedCountryName = country.name;
        _selectedZone = country.zone?.elementAt(0).zoneId;
        _selectedZoneName = country.zone?.elementAt(0).name;
      }
    } else {
      var data = widget.model?.data;
      _firstName.text = data?.firstname ?? "";
      _lastName.text = data?.lastname ?? "";
      _company.text = data?.company ?? "";
      _address1.text = data?.address1 ?? "";
      _address2.text = data?.address2 ?? "";
      _city.text = data?.city ?? "";
      _zip.text = data?.postcode ?? "";
      _selectedCountry = data?.countryId;
      _selectedZone = data?.zoneId;

      var country = widget.model?.getCountryById(_selectedCountry);
      _selectedCountryName = country?.name;
      _selectedZoneName = country?.getZoneById(_selectedZone)?.name;
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _company.dispose();
    _address2.dispose();
    _address1.dispose();
    _city.dispose();
    _zip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppSizes.size8,
          bottom: AppSizes.size16,
          left: AppSizes.size16,
          right: AppSizes.size16),
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // headingText(_localizations?.translate(
                      //     AppStringConstant.contactInformation) ??
                      //     ""),
                      SizedBox(height: AppSizes.size44),
                    ],
                  ),
                  fieldItem(_firstName, AppStringConstant.firstName.localized(),
                      true),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(
                      _lastName, AppStringConstant.lastName.localized(), true),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(
                      _company, AppStringConstant.company.localized(), false),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(
                      _address1, AppStringConstant.address1.localized(), true),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(
                      _address2, AppStringConstant.address2.localized(), false),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(_city, AppStringConstant.city.localized(), true),
                  const SizedBox(height: AppSizes.size16),
                  fieldItem(_zip, AppStringConstant.zip.localized(), true),
                  const SizedBox(height: AppSizes.size16),
                  countryAndStateSpinner(
                      widget.model?.countryData, filterCountry),
                  const SizedBox(height: AppSizes.size16),
                  Newsletter(
                    (value) {
                      _default = value;
                    },
                    AppStringConstant.defaultAddress,
                    showHeading: true,
                    selectedId: widget.model?.defaultValue == 1 ? "1" : "0",
                  ),
                  const SizedBox(height: AppSizes.size16),
                  commonButton(context, () async {
                    if (_selectedZoneName?.isEmpty ?? true) {
                      GenericMethods.showErrorAlertMessages(
                          context,
                          _localizations?.translate(
                                  AppStringConstant.pleseSelectStateErrorMsg) ??
                              "");
                    }

                    if (_selectedZoneName?.compareTo(_localizations?.translate(
                                AppStringConstant.pleaseSelectState) ??
                            "") ==
                        0) {
                      GenericMethods.showErrorAlertMessages(
                          context,
                          _localizations?.translate(
                                  AppStringConstant.pleseSelectStateErrorMsg) ??
                              "please select");
                    }
                    var validate = _formKey.currentState?.validate();
                    if (validate == true) {
                      if (_address1.text.length < 3) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          AlertMessage.showError(
                              _localizations?.translate(AppStringConstant
                                      .add1ShouldBeGreaterThan3character) ??
                                  "Address1 must be between 3 to 128 characters!",
                              context);
                        });
                      } else {
                        widget.onSaveAddress(AddAddressRequest(
                          firstName: _firstName.text,
                          lastName: _lastName.text,
                          company: _company.text,
                          address1: _address1.text,
                          address2: _address2.text,
                          city: _city.text,
                          postcode: _zip.text,
                          zoneId: _selectedZone,
                          countryId: _selectedCountry,
                          defaultValue: _default,
                          wkToken: await AppSharedPref.getWkToken(),
                          customerId: await AppSharedPref.getCustomerId(),
                        ));
                      }
                    }
                  }, AppStringConstant.saveAddress.localized().toUpperCase()),

                  //fieldItem(_controller, "First Name", true),
                ],
              ),
            ),
            if (widget.selectedLanguage == "ar")
              Positioned(
                right: 0,
                child: Container(
                  color: AppColors.white,
                  width: AppSizes.deviceWidth,
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _localizations?.translate(AppStringConstant.location) ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          width: AppSizes.deviceWidth - 105,
                          child: location()),
                    ],
                  ),
                ),
              )
            else
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.size16),
                  width: AppSizes.deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _localizations?.translate(AppStringConstant.location) ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      Container(
                          alignment: Alignment.topRight, child: location()),
                    ],
                  ),
                ),
              )

            /* Positioned(
              left: 0,
              child: Container(
                color: AppColors.white,
                width: AppSizes.deviceWidth,
                child: Row(

                  children: [
                    Text(_localizations?.translate(AppStringConstant.location)??"",
                    style:TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                    Container(
                      alignment: Alignment.topLeft,
                      width: AppSizes.deviceWidth-100,
                      child:location()
                    ),
                  ],
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Widget location() {
    return InkWell(
      onTap: () async {
        var status = await locationReq.Location.instance.hasPermission();
        if (status == locationReq.PermissionStatus.granted ||
            status == locationReq.PermissionStatus.grantedLimited) {
          Navigator.pushNamed(context, AppRoute.location).then((value) {
            if (value is Map) {
              print('values ----- $value');
              filterSelectedCountryAndState(
                value["country"],
                value["state"],
              );
              _city.text = value['city'];
              _zip.text = value['zip'];
              if (!kIsWeb && Platform.isIOS) {
                _address1.text =
                    "${value['street1'] ?? value['street2'] ?? value['street3'] ?? ""}";
                _address2.text =
                    "${value['street1'] ? value['street4'] : value['street3']}";
              } else {
                _address1.text =
                    "${value['street1'] ?? ''}, ${value['street2'] ?? ''}";
                _address2.text = "${value['street3'] ?? ''}";
              }
            }
          });
        } else {
          DialogHelper.locationPermissionDialog(
              AppStringConstant.provideLocationPermission, context,
              onConfirm: () async {
            var status =
                await locationReq.Location.instance.requestPermission();
            if (status == locationReq.PermissionStatus.deniedForever) {
              DialogHelper.locationPermissionDialog(
                  AppStringConstant.provideLocationPermission, context,
                  onConfirm: () async {
                openAppSettings();
              });
            }
          });
        }
      },
      child: const SizedBox(
        width: 35.0,
        height: 35.0,
        /* decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(100))),*/
        child: Icon(
          Icons.my_location,
          // color: AppColors.black,
          size: 30,
        ),
      ),
    );
  }

  void filterSelectedCountryAndState(String? country, String? state) {
    _selectedCountryName = country;
    filterCountry = widget.model?.getCountryByName(country);
    _selectedCountry = filterCountry?.countryId;
    _selectedZone = filterCountry?.getZoneByName(state)?.zoneId;
    /*if(state!=null && state!=""){
    _selectedZoneName = state;
    }else{
      _selectedZoneName =
          _localizations?.translate(AppStringConstant.pleaseSelectState) ?? "";
    }*/

    if (!kIsWeb && Platform.isAndroid) {
    } else {
      _selectedZone = filterCountry?.getZoneByName(state)?.zoneId;
      _selectedZoneName =
          _localizations?.translate(AppStringConstant.pleaseSelectState) ?? "";
    }

    setState(() {});
  }

  Widget fieldItem(
      TextEditingController controller, String label, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(color: AppColors.black, fontSize: 16),
            ),
            if (isRequired)
              Text(
                "*",
                style: TextStyle(color: AppColors.black),
              )
          ],
        ),
        //  const SizedBox(height: AppSizes.size2),
        CommonTextField(
          controller: controller,
          isPassword: false,
          helperText: label,
          isRequired: isRequired,
        ),
      ],
    );
  }

  Widget countryAndStateSpinner(
      List<CountryDatum?>? countryData, CountryDatum? selected) {
    CountryDatum? selectedCountry;
    bool showState = true;
    if (selected != null) {
      selectedCountry = selected;
      if (selected.zone?.isEmpty == false) {
        showState = true;
      } else {
        showState = false;
      }
    }
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStringConstant.country.localized(),
                style: TextStyle(color: AppColors.black),
              ),
              Text(
                "*",
                style: TextStyle(color: AppColors.black),
              )
            ],
          ),
          const SizedBox(height: AppSizes.size8),
          SizedBox(
            // height: 58,
            child: DropdownButtonFormField<CountryDatum?>(
              dropdownColor: Theme.of(context).cardColor,
              // : InputDecoration(
              //   border: OutlineInputBorder()
              // ),
              isDense: true,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.darkGray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.darkGray,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.darkGray,
                  ),
                ),
              ),
              iconEnabledColor: Colors.white,
              hint: Text(_selectedCountryName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: AppSizes.size16)),
              items: countryData
                  ?.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e?.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: AppSizes.size16)),
                      ))
                  .toList(),
              onChanged: (value) {
                _selectedCountryName = value?.name;
                _selectedCountry = value?.countryId;
                filterCountry = value;
                if (value?.zone?.isEmpty == false) {
                  _selectedZone = value?.zone?.elementAt(0).zoneId;
                  _selectedZoneName = value?.zone?.elementAt(0).name;
                  showState = true;
                } else {
                  showState = false;
                }
                selectedCountry = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: AppSizes.size8),
          if (showState)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppStringConstant.state.localized(),
                  style: TextStyle(color: AppColors.black),
                ),
                Text(
                  "*",
                  style: TextStyle(color: AppColors.black),
                )
              ],
            ),
          if (showState) const SizedBox(height: AppSizes.size8),
          if (showState)
            SizedBox(
              // height: 58,
              child: DropdownButtonFormField<Zone?>(
                dropdownColor: Theme.of(context).cardColor,
                isExpanded: true,
                isDense: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.darkGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.darkGray,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
                iconEnabledColor: Colors.white,
                hint: Text(_selectedZoneName ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: AppSizes.size16)),
                items: selectedCountry?.zone
                    ?.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: AppSizes.size16)),
                        ))
                    .toList(),
                onChanged: (value) {
                  _selectedZoneName = value?.name;
                  _selectedZone = value?.zoneId;
                  setState(() {});
                },
              ),
            ),
        ],
      ),
    );
  }
}
