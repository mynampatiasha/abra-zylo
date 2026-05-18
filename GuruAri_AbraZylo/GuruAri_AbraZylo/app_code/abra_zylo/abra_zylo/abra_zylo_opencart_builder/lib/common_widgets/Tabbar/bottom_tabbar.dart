import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_repository.dart';
import 'package:oc_demo/screens/cart/cart_screen.dart';
import 'package:oc_demo/screens/profile/bloc/profile_repository.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_bloc.dart';
import 'package:oc_demo/screens/profile/profile_screen.dart';

import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../screens/category/bloc/categories_screen_bloc.dart';
import '../../screens/category/bloc/categories_screen_repository.dart';
import '../../screens/category/category_screen.dart';
import '../../screens/category_listing/category_listing_screen.dart';
import '../../screens/home/bloc/home_screen_bloc.dart';
import '../../screens/home/bloc/home_screen_repository.dart';
import '../../screens/home/home_screen.dart';
import 'badge_icon_update.dart';

class TabbarController {
  static StreamController<int> countController =
      StreamController<int>.broadcast();

  TabbarController._privateConstructor();

  static final TabbarController _instance =
      TabbarController._privateConstructor();

  factory TabbarController() {
    return _instance;
  }

  static void dispose() {}
}

class BottomTabbarWidget extends StatefulWidget {
  const BottomTabbarWidget({Key? key}) : super(key: key);

  @override
  _BottomTabbarWidgetState createState() => _BottomTabbarWidgetState();
}

class _BottomTabbarWidgetState extends State<BottomTabbarWidget> {
  AppLocalizations? _localizations;
  int _selectedIndex = 0;
  int categoryIndex = 0;
  int categoryPath = -1;

  @override
  void initState() {
    _selectedIndex = 0;
    _setCartBadge();
    super.initState();
  }

  //to sync cart count on badge.
  void _setCartBadge() async {
    TabbarController.countController.sink
        .add(int.parse(await AppSharedPref.getCartCount()));
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void moveToCategory(int index, int path) {
    setState(() {
      _selectedIndex = 1;
      categoryIndex = index;
      categoryPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetList = [
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeScreenBloc>(
            create: (context) => HomeScreenBloc(
              repository: HomeScreenRepositoryImp(),
            ),
          ),
        ],
        child: HomeScreen(moveToCategory),
      ),
      (mAppStoragePref.getIsTabCategoryView() == "0")
          ? MultiBlocProvider(
              providers: [
                BlocProvider<CategoriesScreenBloc>(
                  create: (context) => CategoriesScreenBloc(
                    repository: CategoriesScreenRepositoryImp(),
                  ),
                ),
              ],
              child: CategoriesScreen(
                  selectedIndex: categoryIndex, categoryPath: categoryPath),
            )
          : const CategorySearchScreen(),
      MultiBlocProvider(
        providers: [
          BlocProvider<CartScreenBloc>(
              create: (context) =>
                  CartScreenBloc(repository: CartScreenRepositoryImp()))
        ],
        child: const CartScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileScreenBloc>(
              create: (context) =>
                  ProfileScreenBloc(repository: ProfileRepositoryImp()))
        ],
        child: ProfileScreen(),
      ),
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.canPop(context)
            ? Navigator.pop(context)
            : _selectedIndex != 0
                ? setState(() => _selectedIndex = 0)
                : SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: _widgetList.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          /*    decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 0,
              ),
            ],
          ),*/
          child: BottomNavigationBar(
            backgroundColor:
                Theme.of(context).navigationBarTheme.backgroundColor,
            selectedItemColor: Theme.of(context).textTheme.titleLarge?.color,
            selectedFontSize: 14,
            selectedIconTheme: const IconThemeData(/*color: AppColors.black*/),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              BottomNavigationBarItem(
                label: _localizations?.translate(AppStringConstant.home) ?? '',
                icon: const Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined),
                label:
                    _localizations?.translate(AppStringConstant.categories) ??
                        '',
              ),
              BottomNavigationBarItem(
                icon: const BadgeIconUpdate(),
                /*StreamBuilder(
                  initialData: 0,
                  stream: TabbarController.countController.stream,
                  builder: (_, snapshot) => BadgeIcon(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    badgeCount: int.parse(snapshot.data.toString()),
                  ),
                )*/
                label: _localizations?.translate(AppStringConstant.cart) ?? '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle_outlined),
                label:
                    _localizations?.translate(AppStringConstant.profile) ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
