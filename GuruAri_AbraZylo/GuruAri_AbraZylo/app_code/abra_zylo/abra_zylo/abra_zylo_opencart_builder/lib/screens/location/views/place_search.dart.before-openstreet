import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/google_place_model.dart';
import 'package:oc_demo/screens/location/bloc/location_bloc.dart';
import 'package:oc_demo/screens/location/bloc/location_event.dart';
import 'package:oc_demo/screens/location/bloc/location_state.dart';
import 'package:oc_demo/utils/helper.dart';

class PlaceSearch extends StatefulWidget {
  const PlaceSearch({Key? key}) : super(key: key);

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  TextEditingController searchController = TextEditingController();

  GooglePlaceModel? placeModel;
  bool isLoading = false;
  LocationScreenBloc? _locationScreenBloc;

  @override
  void initState() {
    _locationScreenBloc = context.read<LocationScreenBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationScreenBloc, LocationScreenState>(
      builder: (context, state) {
        if (state is LocationScreenLoadingState) {
          isLoading = true;
        } else if (state is SearchPlaceSuccessState) {
          isLoading = false;
          placeModel = state.data;
          print("length -------${placeModel?.results?.length}");
        } else if (state is SearchPlaceErrorState) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(state.message, context);
          });
        } else if (state is LocationScreenInitialState) {
          isLoading = false;
          placeModel = null;
        }
        return _buildUI();
      },
    );
  }

  Widget _buildUI() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: IconButton(
            onPressed: () {
              Helper.hideSoftKeyBoard();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: TextField(
            autofocus: true,
            controller: searchController,
            onChanged: (searchKey) {
              print(searchKey);
              if (searchKey.isNotEmpty) {
                _locationScreenBloc?.add(SearchPlaceEvent(searchKey));
              } else {
                _locationScreenBloc?.add(SearchPlaceInitialEvent());
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppStringConstant.search.localized(),
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
          actions: [
            searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Helper.hideSoftKeyBoard();
                      searchController.text = "";
                      placeModel = null;
                      _locationScreenBloc?.add(SearchPlaceInitialEvent());
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
                : Container()
          ],
        ),
        body: Column(
          children: [
            ((placeModel != null))
                ? (placeModel?.results?.isNotEmpty ?? false)
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: placeModel?.results?.length ?? 0,
                            itemBuilder: (context, index) => Container(
                                padding: const EdgeInsets.all(AppSizes.size8),
                                margin: const EdgeInsets.all(AppSizes.size8),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(
                                        context,
                                        LatLng(
                                            placeModel?.results?[index].geometry
                                                    ?.location?.lat ??
                                                0.0,
                                            placeModel?.results?[index].geometry
                                                    ?.location?.lng ??
                                                0.0));
                                  },
                                  title: Text(
                                    placeModel?.results?[index].name ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    placeModel?.results?[index]
                                            .formattedAddress ??
                                        '',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ))),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.size8),
                          child: Text(
                            AppStringConstant.noResult.localized(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      )
                : Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
          ],
        ));
  }
}
