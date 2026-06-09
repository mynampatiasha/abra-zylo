import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/address/zone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/cart/country_data_model.dart' as state;
import '../../../models/cart/country_data_model.dart';

class GuestCheckoutShippingAddressForm extends StatefulWidget {
  GuestCheckoutShippingAddressForm(this.countryData, this.onSaveAddress,
      {Key? key})
      : super(key: key);
  final List<CountryData>? countryData;
  final Function(AddAddressRequest, String address) onSaveAddress;

  @override
  State<GuestCheckoutShippingAddressForm> createState() =>
      _GuestCheckoutShippingAddressFormState();
}

class _GuestCheckoutShippingAddressFormState
    extends State<GuestCheckoutShippingAddressForm> {
  AppLocalizations? localizations;
  late GlobalKey<FormState> _formKey;
  // for switch use to make shipping address same as billing address
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
    // For United Kingdom
    _selectedCountry = "222";
    // _default = "0";
    // _checked==true;
    //  _prepareTextFields();
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
      padding: const EdgeInsets.all(AppSizes.size16),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  localizations?.translate(AppStringConstant.shippingAddress) ??
                      "Shipping Address",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        LocationPermission permission = await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                        }
                        
                        if (permission == LocationPermission.deniedForever) {
                          DialogHelper.locationPermissionDialog(
                              AppStringConstant.provideLocationPermission, context,
                              onConfirm: () async {
                            await Geolocator.openAppSettings();
                          });
                          return;
                        }
                
                        if (permission == LocationPermission.whileInUse ||
                            permission == LocationPermission.always) {
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
                              _address1.text = value['street1'];
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
                fieldItem(
                    _email,
                    localizations?.translate(AppStringConstant.email) ??
                        "Email",
                    true),
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
                countryAndStateSpinner(widget.countryData),
                const SizedBox(height: AppSizes.size16),
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
                              email: _email.text,
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
    _selectedZoneName = state;
    var selectedCountry = getCountryByName(country);
    _selectedCountry = selectedCountry?.countryId;
    _selectedZone = selectedCountry?.getZoneByName(state)?.zoneId;
    setState(() {});
  }

  Widget fieldItem(
      TextEditingController controller, String label, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(label),
            if (isRequired)
              const Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
          ],
          mainAxisSize: MainAxisSize.min,
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

  Widget countryAndStateSpinner(List<CountryData?>? countryData) {
    CountryData? selectedCountry;
    print("country data  is >>>>${countryData}");
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
                style: TextStyle(color: Colors.red),
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
                style: TextStyle(color: Colors.red),
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
