import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';
import 'package:oc_demo/screens/login_signup/view/signup_extra_views.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_event.dart';

import '../bloc/return_order_state.dart';

class ReturnOrderForm extends StatefulWidget {
  const ReturnOrderForm(this.model, this.productId, this.bloc, {Key? key})
      : super(key: key);
  final ReturnOrderRequest? model;
  final String? productId;
  final ReturnOrderBloc? bloc;

  @override
  State<ReturnOrderForm> createState() => _ReturnOrderFormState();
}

class _ReturnOrderFormState extends State<ReturnOrderForm> {
  AppLocalizations? _localizations;
  ReturnReasons? returnReason;
  String opened = "0";
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _orderId = TextEditingController();
  TextEditingController _orderDate = TextEditingController();
  TextEditingController _productName = TextEditingController();
  TextEditingController _productCode = TextEditingController();
  TextEditingController _productQuantity = TextEditingController();
  TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    print("----< Return page");
    super.initState();
    _firstName.text = widget.model?.firstname ?? "";
    _lastName.text = widget.model?.lastname ?? "";
    _email.text = widget.model?.email ?? "";
    _telephone.text = widget.model?.telephone ?? "";
    _orderId.text = widget.model?.orderId ?? "";
    _orderDate.text = widget.model?.dateOrdered ?? "";
    _productName.text = widget.model?.product ?? "";
    _productCode.text = widget.model?.model ?? "";
    _productQuantity.text = "1";
    /* returnReason = widget.model?.returnReasons?[0];*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size16, vertical: AppSizes.size8),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.size16),
                  child: Text(
                    AppStringConstant.orderInformation.localized(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                fieldItem(
                    _firstName, AppStringConstant.firstName.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _lastName, AppStringConstant.lastName.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _email, AppStringConstant.emailAddress.localized(), false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _telephone, AppStringConstant.telephone.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _orderId, AppStringConstant.orderId.localized(), false),
                const SizedBox(height: AppSizes.size16),
                InkWell(
                  onTap: () {
                    DateTime selectedDate =
                        DateFormat("yyyy-MM-dd").parse(_orderDate.text);
                    _selectDate(context, selectedDate);
                  },
                  child: fieldItem(_orderDate,
                      AppStringConstant.dateOrdered.localized(), true,
                      isEnabled: false),
                ),
                const SizedBox(height: AppSizes.size16),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.size16),
                  child: Text(
                    _localizations
                            ?.translate(AppStringConstant.productInformation) ??
                        "",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                fieldItem(_productName,
                    AppStringConstant.productName.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_productCode,
                    AppStringConstant.productCode.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_productQuantity,
                    AppStringConstant.quantity.localized(), true),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    null, AppStringConstant.reasonForReturn.localized(), true,
                    data: dropDown(widget.model?.returnReasons ?? [])),

                const SizedBox(height: AppSizes.size16),
                fieldItem(null, AppStringConstant.opened.localized(), true,
                    data: Newsletter(
                      (value) {},
                      "",
                      showHeading: false,
                      selectedId: opened,
                    )),
                fieldItem(_comment,
                    AppStringConstant.faultyOrOtherDetails.localized(), false),
                const SizedBox(height: AppSizes.size16),
                const SizedBox(height: AppSizes.size16),
                commonButton(
                  context,
                  () async {
                    var validate = _formKey.currentState?.validate();
                    if (validate == true) {
                      widget.bloc?.emit(ReturnOrderInitial());
                      widget.bloc?.add(ReturnOrderSubmitEvent(
                          widget.model?.orderId,
                          widget.productId,
                          _firstName.text,
                          _lastName.text,
                          _email.text,
                          _telephone.text,
                          _orderDate.text,
                          _productName.text,
                          _productCode.text,
                          _productQuantity.text,
                          returnReason?.returnReasonId,
                          opened,
                          _comment.text));
                    }
                  },
                  AppStringConstant.submit.localized(),
                ),
                //fieldItem(_controller, "First Name", true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDown(List<ReturnReasons> list) {
    return DropdownButtonFormField<ReturnReasons>(
      value: returnReason ?? (list.isNotEmpty ? list.first : null),
      dropdownColor: Theme.of(context).cardColor,
      decoration:
          formFieldDecoration(context, "", "", isDense: true, isRequired: true),
      onChanged: (ReturnReasons? value) {
        returnReason = value;
      },
      items: list
          .map((e) => DropdownMenuItem<ReturnReasons>(
                value: e,
                child: Text(
                  e.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: AppSizes.size16),
                ),
              ))
          .toList(),
    );
  }

  Widget fieldItem(
      TextEditingController? controller, String label, bool isRequired,
      {Widget? data, bool isEnabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _localizations?.translate(label) ?? "",
              style: TextStyle(color: AppColors.black),
            ),
            if (isRequired)
              const Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
        const SizedBox(height: AppSizes.size8),
        data ??
            CommonTextField(
              controller: controller!,
              isPassword: false,
              helperText: label,
              isRequired: isRequired,
              enable: isEnabled,
              suffix: isEnabled
                  ? null
                  : const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.black,
                    ),
            ),
      ],
    );
  }

  _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      _orderDate.text = DateFormat("yyyy-MM-dd").format(selected);
    }
  }
}
