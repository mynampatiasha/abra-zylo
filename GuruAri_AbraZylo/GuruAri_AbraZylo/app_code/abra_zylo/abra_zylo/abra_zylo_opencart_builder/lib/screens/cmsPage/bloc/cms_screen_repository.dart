import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/cmsDetailModel/cms_detail_model.dart';

import '../../../network_manager/api_client.dart';

abstract class CMSScreenRepository {
  Future<CmsDetailModel> getMorePageData(String? id);
}

class CMSScreenRepositoryImp implements CMSScreenRepository {
  @override
  Future<CmsDetailModel> getMorePageData(String? id) async {
    return await ApiClient()
        .getCmsPageDetail(await AppSharedPref.getWkToken(), id!);
  }
}
