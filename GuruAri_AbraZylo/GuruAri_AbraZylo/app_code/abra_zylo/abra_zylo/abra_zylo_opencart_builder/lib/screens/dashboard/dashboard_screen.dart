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
                        // color: Theme.of(context).cardColor,
                        // margin: const EdgeInsets.only(top: AppSizes.imageRadius),
                        padding: const EdgeInsets.all(AppSizes.size8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // background
                            // foreground
                            side: BorderSide(
                              width: 1.0,
                              color:
                                  (MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? AppColors.black
                                      : AppColors.white),
                            ),
                            shape: const RoundedRectangleBorder(),
                          ),

                          // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).textTheme.headlineMedium?.color),
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoute.orderList,
                                arguments: false);
                          },
                          child: Text(
                            _localizations
                                    ?.translate(AppStringConstant.viewAll)
                                    .toUpperCase() ??
                                '',

                            // style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).cardColor)
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
          //isScrollable: true,

          indicatorColor: AppColors.black,
          indicatorPadding: const EdgeInsets.only(
              left: AppSizes.size18, right: AppSizes.size18),
          unselectedLabelColor: Colors.grey,
          dividerColor: Theme.of(context).cardColor,

          unselectedLabelStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          // Color of unselected tab labels
          labelColor: AppColors.black,
          labelStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),

          controller: _tabController,
          labelPadding: const EdgeInsets.all(0.0),

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

  Tab _getTab(
    title,
  ) {
    return Tab(
      child: Container(
        width: AppSizes.deviceWidth / 2,
        // height: AppSizes.deviceHeight / 20,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
        color: Theme.of(context).cardColor,
        child: Center(
            child: Text(
          title,
          // style: TextStyle(
          //
          //     color: (SchedulerBinding.instance!.window.platformBrightness == Brightness.dark
          //         ? AppColors.white
          //         : AppColors.black)
          // )
          // ),
        )),
      ),
    );
  }
}
