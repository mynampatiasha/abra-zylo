import 'dart:convert';

import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

abstract class SearchRepository {
  Future<SearchModel> getSearchSuggestion(String text);
}

class SearchRepositoryImp implements SearchRepository {
  @override
  Future<SearchModel> getSearchSuggestion(String text) async {
    return await ApiClient()
        .searchSuggestions(text, await AppSharedPref.getWkToken());
  }
}
