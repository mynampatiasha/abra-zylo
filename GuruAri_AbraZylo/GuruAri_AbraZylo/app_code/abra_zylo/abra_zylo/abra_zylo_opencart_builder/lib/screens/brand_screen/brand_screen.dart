import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:oc_demo/screens/brand_screen/bloc/brand_screen_bloc.dart';
import 'package:oc_demo/screens/brand_screen/bloc/brand_screen_state.dart';

import '../../common_widgets/alert_message.dart';
import '../../constants/app_constants.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/carousel/carousel_model.dart';
import '../../models/catalog/request/catalog_product_request.dart';
import 'bloc/brand_screen_event.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen(this.carouselId, {Key? key}) : super(key: key);
  final String carouselId;
//  final List<ImageManufacturer>? carousel;

  @override
  State<BrandScreen> createState() {
    return _BrandScreeState();
  }
}

class _BrandScreeState extends State<BrandScreen> {
  BrandScreenBloc? brandScreenBloc;
  bool isLoading = true;
  CatalogProductRequest? _request;
  late int _page;
  late ScrollController _scrollController;
  CarouselModel? carouselModel;

  @override
  void initState() {
    brandScreenBloc = context.read<BrandScreenBloc>();
    //Call api to get brand carousel
    _scrollController = ScrollController()..addListener(setupPagination);
    _page = 1;
    _callAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppBar(
          "Browse by Brands",
          context,
          isHomeEnable: false,
        ),
        body: BlocBuilder<BrandScreenBloc, BrandScreenState>(
            builder: (context, state) {
          if (state is BrandScreenStateInitial) {
            isLoading = true;
          } else if (state is BrandScreenStateSuccess) {
            isLoading = false;
            carouselModel = state.carouselModel;
          } else if (state is BrandScreenStateError) {
            isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          }

          return createBannerView();
        }),
      ),
    );
  }

  setupPagination() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
      if (hasMoreData()) {
        _page += 1;
        _callAPI();
      }
    }
  }

  _callAPI() {
    isLoading = true;
    AppSharedPref.getWkToken().then((value) {
      _request = CatalogProductRequest(
        width: AppSizes.deviceWidth.toInt().toString(),
        limit: "10",
        path: widget.carouselId,
        page: _page.toString(),
        token: value,
        /*  manufactureId: home == true ? catalogId : null,*/
      );

      /* if (_sort != null) {
        _request.sort = _sort?.value;
        _request.order = _sort?.order;
      } else {
        _request.sort = null;
        _request.order = null;
      }
      if (_filter != null) {
        _request.filter = _filter;
      } else {
        _request.filter = null;
      }*/

      brandScreenBloc?.add(BrandScreenFetchCarousel(_request!));
      //  label = widget.arguments[labelKey];
    });
  }

  bool hasMoreData() {
    return ((carouselModel?.totalCount ?? 0) >
            (carouselModel?.imageManufacturer?.length ?? 0) &&
        isLoading);
  }

  Widget createBannerView() {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.1),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(
              carouselModel?.imageManufacturer
                      ?.elementAt(index)
                      .manufacturerId ??
                  "",
              carouselModel?.imageManufacturer?.elementAt(index).name ?? "",
              "",
              true,
            ),
          );
        },
        child: Card(
          child: ImageView(
            url: carouselModel?.imageManufacturer?.elementAt(index).image,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      itemCount: carouselModel?.imageManufacturer?.length ?? 0,
    );
  }
}
/*
*
* */
