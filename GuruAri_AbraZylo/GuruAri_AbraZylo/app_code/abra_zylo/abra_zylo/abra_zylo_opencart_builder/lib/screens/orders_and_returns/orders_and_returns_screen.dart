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
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/models/guestOrderReturn/GuestOrderReturn.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_text_field.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import 'bloc/orders_and_returns_screen_bloc.dart';
import 'bloc/orders_and_returns_screen_events.dart';
import 'bloc/orders_and_returns_screen_state.dart';

class OrdersAndReturns extends StatefulWidget {
  const OrdersAndReturns({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrdersAndReturnsState();
}

class _OrdersAndReturnsState extends State<OrdersAndReturns> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _billingLastNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _billingZipCodeController =
      TextEditingController();

  var findBy = -1;
  List<String> dropDownList = ["Email", "Zip"];

  late FocusNode _orderIdFocusNode,
      _billingLastNameFocusNode,
      _emailFocusNode,
      _billingZipCodeFocusNode;

  late AppLocalizations? _localizations;
  late bool _loading;
  late GlobalKey<FormState> _formKey;
  OrdersAndReturnsBloc? _bloc;
  GuestOrderReturn? _model;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _loading = false;
    _formKey = GlobalKey();
    _bloc = context.read<OrdersAndReturnsBloc>();

    _orderIdFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _billingZipCodeFocusNode = FocusNode();
    _billingLastNameFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return BlocConsumer<OrdersAndReturnsBloc, OrdersAndReturnsState>(
        listenWhen: (previous, currentState) {
      return currentState is OrdersAndReturnsSuccessState;
    }, listener: (BuildContext context, OrdersAndReturnsState currentState) {
      if (currentState is OrdersAndReturnsSuccessState) {
        _loading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (currentState.data?.error != 0) {
            AlertMessage.showSuccess(currentState.data?.message ?? '', context);
            Navigator.of(context).pushNamed(
              AppRoute.orderDetail,
              arguments: _orderIdController.text.toString() ?? "",
            );
          } else {
            AlertMessage.showError(currentState.data?.message ?? '', context);
          }
        });
      }
    }, builder: (BuildContext context, OrdersAndReturnsState currentState) {
      if (currentState is OrdersAndReturnsLoadingState) {
        _loading = true;
      } else if (currentState is OrdersAndReturnsErrorState) {
        _loading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message ?? '', context);
        });
        _bloc?.emit(OrdersAndReturnsEmptyState());
      }
      return _buildUI();
    });
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: commonAppBar(
              _localizations?.translate(AppStringConstant.ordersAndReturns) ??
                  "",
              context,
              isLeadingEnable: true, onPressed: () {
            Navigator.pop(context);
          }),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: AppSizes.size16,
                            ),
                            CommonTextField(
                              focusNode: _orderIdFocusNode,
                              controller: _orderIdController,
                              isRequired: true,
                              isPassword: false,
                              hintText: _localizations
                                      ?.translate(AppStringConstant.orderId) ??
                                  "",
                              inputType: TextInputType.name,
                            ),
                            const SizedBox(height: AppSizes.size16),
                            CommonTextField(
                              focusNode: _billingLastNameFocusNode,
                              controller: _billingLastNameController,
                              isPassword: false,
                              hintText: _localizations?.translate(
                                      AppStringConstant.billingLastName) ??
                                  "",
                              isRequired: true,
                              inputType: TextInputType.name,
                            ),
                            const SizedBox(height: AppSizes.size16),
                            DropdownButtonFormField<String>(
                              elevation: 2,
                              value: null,
                              menuMaxHeight: AppSizes.deviceHeight / 2,
                              decoration: formFieldDecoration(
                                  context,
                                  "",
                                  _localizations?.translate(
                                          AppStringConstant.findOrderBy) ??
                                      "",
                                  isDense: true,
                                  isRequired: true),
                              items:
                                  (dropDownList ?? []).map((String optionData) {
                                return DropdownMenuItem(
                                  value: optionData,
                                  child: Text(
                                    optionData ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // this will call once the value changes
                                setState(() {
                                  findBy =
                                      dropDownList.indexOf(value.toString());
                                });
                              },
                              validator: (value) => value == null
                                  ? _localizations?.translate(
                                          AppStringConstant.required) ??
                                      ""
                                  : null,
                              // validator: (value) {
                              //   if (value == null) {
                              //     // add validation with return statement
                              //   }
                              // },
                            ),
                            const SizedBox(height: AppSizes.size16),
                            if (findBy == 0)
                              CommonTextField(
                                focusNode: _emailFocusNode,
                                hintText: _localizations
                                        ?.translate(AppStringConstant.email) ??
                                    "",
                                controller: _emailController,
                                isRequired: findBy == 0,
                                isPassword: false,
                                inputType: TextInputType.text,
                              ),
                            if (findBy == 1)
                              CommonTextField(
                                focusNode: _billingZipCodeFocusNode,
                                hintText: _localizations?.translate(
                                        AppStringConstant.billingZipCode) ??
                                    "",
                                controller: _billingZipCodeController,
                                isRequired: findBy == 1,
                                isPassword: false,
                                inputType: TextInputType.text,
                              ),
                            const SizedBox(height: AppSizes.size16 * 1.5),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true) {
                              _bloc?.add(OrdersAndReturnsDetailsEvent(
                                  _orderIdController.text,
                                  _emailController.text,
                                  _billingLastNameController.text,
                                  _billingZipCodeController.text));
                            }
                          },
                          child: Center(
                              child: Text(
                            (_localizations
                                        ?.translate(AppStringConstant.submit) ??
                                    "")
                                .toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ))),
                    ),
                  ),

                  // const SizedBox(height: AppSizes.size16),
                ],
              ),
            ),
          ),
        ),
        Visibility(visible: _loading, child: const Loader())
      ],
    );
  }
}
