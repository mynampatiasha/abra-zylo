import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/address/edit_address_book.dart';
import 'package:oc_demo/screens/add_edit_address/bloc/add_edit_address_screen_bloc.dart';
import 'package:oc_demo/screens/add_edit_address/bloc/add_edit_address_screen_event.dart';
import 'package:oc_demo/screens/add_edit_address/bloc/add_edit_address_state.dart';
import 'package:oc_demo/screens/add_edit_address/widget/address_form.dart';
import '../../helper/app_shared_pref.dart';

class AddEditAddress extends StatefulWidget {
  const AddEditAddress(this.addressId, {this.initialLocationData, super.key});
  final String? addressId;
  final Map<String, dynamic>? initialLocationData;

  @override
  State<AddEditAddress> createState() => _AddEditAddressState();
}

class _AddEditAddressState extends State<AddEditAddress> {
  late bool _isLoading;

  EditAddressBook? _addressModel;

  AddEditAddressScreenBloc? _bloc;
  String selectedLanguage = "";

  @override
  void initState() {
    AppSharedPref.getLanguage().then((value) {
      selectedLanguage = value;
    });
    _isLoading = true;
    _bloc = context.read<AddEditAddressScreenBloc>();

    _bloc?.add(AddressDetailFetchEvent(widget.addressId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        widget.addressId == null
            ? AppStringConstant.addNewAddress.localized()
            : AppStringConstant.editAddress.localized(),
        context,
      ),
      body: BlocBuilder<AddEditAddressScreenBloc, AddEditAddressState>(
        builder: (context, state) {
          if (state is AddEditAddressInitial) {
            _isLoading = true;
          } else if (state is AddressDetailFetchSuccess) {
            _isLoading = false;
            _addressModel = state.model;
          } else if (state is AddAddressSuccess) {
            _isLoading = false;
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              if (state.model.error == 0 || state.model.error == "0") {
                String successMsg = state.model.message is String ? state.model.message : 'Address saved successfully';
                AlertMessage.showSuccess(successMsg, context);
                Navigator.of(context).pop(true);
              } else {
                String errorMessage = "Failed to save address.";
                if (state.model.message is String) {
                  errorMessage = state.model.message;
                } else if (state.model.error is Iterable) {
                  errorMessage = (state.model.error as Iterable).join("\n");
                } else if (state.model.error is Map) {
                  errorMessage = (state.model.error as Map).values.join("\n");
                } else if (state.model.message is Map) {
                  errorMessage = (state.model.message as Map).values.join("\n");
                }
                AlertMessage.showError(errorMessage, context);
              }
            });
          } else if (state is AddEditAddressError) {
            _isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          }
          return buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: _addressModel != null,
            child: AddressForm(_addressModel, (request) {
              request.addressId = widget.addressId;
              _bloc?.add(AddAddressEvent(request));
              _bloc?.add(LoadingAddAddressEvent());
            }, selectedLanguage, initialLocationData: widget.initialLocationData),
          ),
          Visibility(
            visible: _isLoading,
            child: const Loader(),
          ),
        ],
      ),
    );
  }
}
