import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/screens/address_book/address_book.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_bloc.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_repository.dart';
import 'package:oc_demo/screens/dashboard/views/collapse_appbar.dart';
import '../../common_widgets/common_banner_view.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../orders_list/bloc/order_screen_bloc.dart';
import '../orders_list/bloc/order_screen_repository.dart';
import '../orders_list/orders_screen.dart';
import '../profile/bloc/profile_repository.dart';
import '../profile/bloc/profile_screen_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool defaultShipping = false;
  bool showAddressPage = false;
  TabController? _tabController;
  AppLocalizations? _localizations;
  String? name, email;
  String? billingAddressUrl;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  Widget orderScreen = BlocProvider(
      create: (context) =>
          OrderScreenBloc(repository: OrderScreenRepositoryImp()),
      child: OrderScreen(true));

  Widget addressBook = BlocProvider(
      create: (context) =>
          AddressBookScreenBloc(repository: AddressBookRepositoryImp()),
      child: AddressBook(
        isFromDashboard: true,
      ));

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: commonToolBar(
            _localizations?.translate(AppStringConstant.dashboard) ?? "",
            context,
            isElevated: false),
        body: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: collapseAppBar(
        context,
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileScreenBloc>(
                create: (context) =>
                    ProfileScreenBloc(repository: ProfileRepositoryImp()))
          ],
          child: CommonBannerView(),
        ),
        Stack(children: [
          TabBarView(
              //   physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Column(
                  children: [
                    Expanded(child: orderScreen),
                    Container(
                        width: AppSizes.deviceWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5232a8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoute.orderList,
                                arguments: false);
                          },
                          child: Text(
                            _localizations
                                    ?.translate(AppStringConstant.viewAll)
                                    .toUpperCase() ??
                                'VIEW ALL',
                            style: const TextStyle(
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ))
                  ],
                ),
                addressBook,
                // orderScreen,
              ]),
          Visibility(visible: isLoading, child: const Loader())
        ]),
        tabBar: TabBar(
          indicatorColor: const Color(0xFF5232a8), // violet-700
          indicatorWeight: 2.5,
          indicatorPadding: EdgeInsets.zero,
          unselectedLabelColor: const Color(0xFF8f889c), // ink-soft
          dividerColor: const Color(0xFFece7f3), // line
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Karla',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          labelColor: const Color(0xFF2b2540), // ink
          labelStyle: const TextStyle(
            fontFamily: 'Karla',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          controller: _tabController,
          labelPadding: EdgeInsets.zero,

          tabs: [
            _getTab(_localizations?.translate(AppStringConstant.recentOrders) ??
                ''),
            _getTab(
                _localizations?.translate(AppStringConstant.addressBook) ?? '')
          ],
        ),
      ),
    );
  }

  Tab _getTab(String title) {
    return Tab(
      child: Container(
        width: AppSizes.deviceWidth / 2,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        color: Colors.transparent,
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
