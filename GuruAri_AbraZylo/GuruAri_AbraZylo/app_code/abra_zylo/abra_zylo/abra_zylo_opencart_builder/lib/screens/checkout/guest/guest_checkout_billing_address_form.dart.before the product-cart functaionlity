import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:location/location.dart' as locationReq;
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/address/country_datum.dart';
import '../../../models/cart/country_data_model.dart' as state;
import '../../../models/cart/country_data_model.dart';
import '../../../utils/validator.dart';

class GuestCheckoutBillingAddressForm extends StatefulWidget {
  GuestCheckoutBillingAddressForm(
      this.countryData, this.onSaveAddress, this.sameAsBilling, this._checked,
      {super.key});
  final List<CountryData>? countryData;
  final Function(AddAddressRequest, String address) onSaveAddress;
  final Function(bool) sameAsBilling;
  bool? _checked;

  @override
  State<GuestCheckoutBillingAddressForm> createState() =>
      _GuestCheckoutBillingAddressFormState();
}

class _GuestCheckoutBillingAddressFormState
    extends State<GuestCheckoutBillingAddressForm> {
  AppLocalizations? localizations;
  late GlobalKey<FormState> _formKey;

  late TextEditingController _firstName,
      _lastName,
      _email,
      _telephone,
      _company,
      _address1,
      _address2,
      _city,
      _zip;
  String? _selectedCountry,
      _selectedZone,
      _selectedCountryName,
      _selectedZoneName,
      _default;
  String? emailErrorMessage;

  CountryData? filterCountry;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _formKey = GlobalKey();
    _firstName = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _telephone = TextEditingController(text: "");
    _company = TextEditingController(text: "");
    _address1 = TextEditingController(text: "");
    _address2 = TextEditingController(text: "");
    _city = TextEditingController(text: "");
    _zip = TextEditingController(text: "");
    _selectedCountryName =
        localizations?.translate((AppStringConstant.selectCountry));
    _selectedZoneName =
        localizations?.translate((AppStringConstant.selectState));
    _selectedZone = "";
    _selectedCountry = "222";
    super.initState();
  }

  CountryData? getCountryById(String? id) {
    for (var country in (widget.countryData ?? <CountryData?>[])) {
      if (country?.countryId == id) {
        return country;
      }
    }
    return widget.countryData?.isNotEmpty == true
        ? widget.countryData?.elementAt(0)
        : null;
  }

  CountryData? getCountryByName(String? countryName) {
    for (var country in (widget.countryData ?? <CountryData?>[])) {
      if (country?.name?.toLowerCase() == countryName?.toLowerCase()) {
        return country;
      }
    }
    return widget.countryData?.isNotEmpty == true
        ? widget.countryData?.elementAt(0)
        : null;
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _telephone.dispose();
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
      padding: const EdgeInsets.fromLTRB(
          AppSizes.size16, AppSizes.size16, AppSizes.size16, AppSizes.size4),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  localizations?.translate(AppStringConstant.billingAddress) ??
                      "Billing Address",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        var status =
                            await locationReq.Location.instance.hasPermission();
                        if (status == locationReq.PermissionStatus.granted ||
                            status ==
                                locationReq.PermissionStatus.grantedLimited) {
                          Navigator.pushNamed(context, AppRoute.location)
                              .then((value) {
                            if (value is Map) {
                              print('values ----- $value');
                              filterSelectedCountryAndState(
                                value["country"],
                                value["state"],
                              );
                              _city.text = value['city'];
                              _zip.text = value['zip'];
                              if (Platform.isIOS) {
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
                              AppStringConstant.requiredLocationPermission,
                              context, onConfirm: () async {
                            var status = await locationReq.Location.instance
                                .requestPermission();
                            if (status ==
                                locationReq.PermissionStatus.deniedForever) {
                              DialogHelper.locationPermissionDialog(
                                  AppStringConstant.provideLocationPermission,
                                  context, onConfirm: () async {
                                openAppSettings();
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        width: AppSizes.size34,
                        height: AppSizes.size34,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.size100))),
                        child: Icon(
                          Icons.my_location,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                    )
                  ],
                ),
                fieldItem(
                    _firstName,
                    localizations?.translate(AppStringConstant.firstname) ??
                        "First Name",
                    true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _lastName,
                    localizations?.translate(AppStringConstant.lastname) ??
                        "Last Name",
                    true),
                const SizedBox(height: AppSizes.size16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(localizations?.translate(AppStringConstant.email) ??
                        "Email"),
                    // if (isRequired)
                    const Text(
                      "*",
                      style: TextStyle(color: AppColors.red),
                    )
                  ],
                  mainAxisSize: MainAxisSize.max,
                ),
                const SizedBox(height: AppSizes.size8),
                TextFormField(
                  controller: _email,
                  decoration: formFieldDecoration(
                      context,
                      "",
                      localizations
                              ?.translate(AppStringConstant.emailAddress) ??
                          "",
                      isRequired: true),
                  autovalidateMode: (_email.text.isNotEmpty)
                      ? AutovalidateMode.always
                      : AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return Validator.isEmailValid(value ?? '', context);
                  },
                  /*onChanged: (value) async {
                    if (Validator.isEmailValid(value, context) == null) {
                      var wkToken = await AppSharedPref.getWkToken();
                      bloc?.add(CheckEmailEvent(value, wkToken));
                    } else {
                      emailErrorMessage = null;
                    }
                  },*/
                ),
                if (emailErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.size4),
                    child: Text(
                      emailErrorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.red),
                    ),
                  ),
                // fieldItem(_email, localizations?.translate(AppStringConstant.email)??"Email", true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _telephone,
                    localizations?.translate(AppStringConstant.telephone) ??
                        "Telephone",
                    true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _company,
                    localizations?.translate(AppStringConstant.company) ??
                        "Company",
                    false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _address1,
                    localizations?.translate(AppStringConstant.address1) ??
                        "Address 1",
                    true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _address2,
                    localizations?.translate(AppStringConstant.address2) ??
                        "Address 2",
                    false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _city,
                    localizations?.translate(AppStringConstant.city) ?? "City",
                    true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _zip,
                    localizations?.translate(AppStringConstant.zip) ?? "Zip",
                    true),
                const SizedBox(height: AppSizes.size16),
                countryAndStateSpinner(widget.countryData, filterCountry),
                const SizedBox(height: AppSizes.size16),
                //if(widget._openScreenForShippingAddress==false)
                Padding(
                  padding: const EdgeInsets.all(AppSizes.size8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text((localizations?.translate(
                                  AppStringConstant.sameAsBilling) ??
                              "")),
                          Switch(
                            onChanged: (bool value) {
                              widget._checked = value;
                              setState(() {
                                widget.sameAsBilling(value);
                              });
                            },
                            value: widget._checked ?? true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.size16),
                commonButton(
                  context,
                  () async {
                    var validate = _formKey.currentState?.validate();
                    if (validate == true) {
                      if (_address1.text.length < 3) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          AlertMessage.showError(
                              localizations?.translate(AppStringConstant
                                      .add1ShouldBeGreaterThan3character) ??
                                  "Address1 must be between 3 to 128 characters!",
                              context);
                        });
                        return;
                      } else {
                        String str =
                            "${_firstName.text} ${_lastName.text}, ${_company.text}, ${_address1.text}, ${_city.text}-${_zip.text}, $_selectedCountryName, ${_telephone.text}";
                        widget.onSaveAddress(
                            AddAddressRequest(
                              firstName: _firstName.text,
                              lastName: _lastName.text,
                              email: _email.text.trim(),
                              telephone: _telephone.text,
                              company: _company.text,
                              address1: _address1.text,
                              address2: _address2.text,
                              city: _city.text,
                              postcode: _zip.text,
                              zoneId: _selectedZone,
                              countryId: _selectedCountry,
                            ),
                            str);
                      }
                    }
                  },
                  localizations?.translate(AppStringConstant.saveAddress) ??
                      "Save Address",
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterSelectedCountryAndState(String? country, String? state) {
    _selectedCountryName = country;
    //_selectedZoneName = state;
    filterCountry = getCountryByName(country);
    _selectedCountry = filterCountry?.countryId;
    _selectedZone = filterCountry?.getZoneByName(state)?.zoneId;
    if (Platform.isAndroid) {
      _selectedZone = filterCountry?.getZoneByName(state)?.zoneId;
      _selectedZoneName = state;
    } else {
      _selectedZone = filterCountry?.getZoneByName(state)?.zoneId;
      _selectedZoneName =
          localizations?.translate(AppStringConstant.pleaseSelectState) ?? "";
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
            Text(label),
            if (isRequired)
              const Text(
                "*",
                style: TextStyle(color: AppColors.red),
              )
          ],
        ),
        const SizedBox(height: AppSizes.size8),
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
      List<CountryData?>? countryData, CountryData? selected) {
    CountryData? selectedCountry;
    if (selected != null) {
      selectedCountry = selected;
    }
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Country"),
              Text(
                "*",
                style: TextStyle(color: AppColors.red),
              )
            ],
          ),
          const SizedBox(height: AppSizes.size8),
          SizedBox(
            height: AppSizes.size58,
            child: DropdownButtonFormField<CountryData?>(
              // : InputDecoration(
              //   border: OutlineInputBorder()
              // ),
              dropdownColor: Theme.of(context).cardColor,
              isDense: true,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
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
                print("country data  is >>${countryData}");
                _selectedCountryName = value?.name;
                _selectedCountry = value?.countryId;
                if (value?.zone?.isEmpty == false) {
                  _selectedZone = value?.zone?.elementAt(0).zoneId;
                  _selectedZoneName = value?.zone?.elementAt(0).name;
                } else {
                  _selectedZoneName = localizations
                      ?.translate(AppStringConstant.noStateAvailable);
                  _selectedZone = "";
                }
                selectedCountry = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: AppSizes.size8),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("State"),
              Text(
                "*",
                style: TextStyle(color: AppColors.red),
              )
            ],
          ),
          const SizedBox(height: AppSizes.size8),
          SizedBox(
            height: AppSizes.size58,
            child: DropdownButtonFormField<state.Zone?>(
              alignment: Alignment.topLeft,
              isExpanded: true,
              isDense: true,
              dropdownColor: Theme.of(context).cardColor,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    color: AppColors.black,
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
