import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/loader.dart';
import '../../models/cmsDetailModel/cms_detail_model.dart';
import 'bloc/cms_page_bloc.dart';
import 'bloc/cms_page_event.dart';
import 'bloc/cms_screen_state.dart';

class CMSPageView extends StatefulWidget {
  Map<String, dynamic> arguments;

  CMSPageView(this.arguments, {Key? key}) : super(key: key);

  @override
  State<CMSPageView> createState() => _CMSPageViewState();
}

class _CMSPageViewState extends State<CMSPageView> {
  CMSScreenBloc? _cmsScreenBloc;

  bool isLoading = true;
  double opacity = 0;
  CmsDetailModel? cmsPageDetail;
  WebViewController? _webViewController;

  @override
  void didChangeDependencies() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).cardColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString("",
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  @override
  initState() {
    _cmsScreenBloc = context.read<CMSScreenBloc>();
    _cmsScreenBloc
        ?.add(CMSScreenDataFetchEvent(widget.arguments[cmsPageId] ?? "1"));

    cmsPageDetail = null;
    super.initState();
  }

  @override
  void dispose() {
    cmsPageDetail = null;
    _cmsScreenBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: commonAppBar(widget.arguments[cmsPageTitle] ?? "", context),
        body: BlocBuilder<CMSScreenBloc, CMSScreenState>(
          builder: (context, currentState) {
            if (currentState is CMSScreenInitial) {
              isLoading = true;
              cmsPageDetail = null;
            } else if (currentState is CMSScreenSuccess) {
              cmsPageDetail = currentState.cmsPageDetail;
              isLoading = false;
              _loadHtmlFromAssets(_webViewController);
            } else if (currentState is CMSScreenError) {
              isLoading = false;
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                AlertMessage.showError(currentState.message ?? '', context);
              });
            }
            //test
            return _buildUI(cmsPageDetail);
          },
        ));
  }

  Widget _buildUI(CmsDetailModel? cmsPageDetail) {
    return Stack(
      children: [
        Visibility(
          visible: !isLoading,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: WebViewWidget(
              controller: _webViewController!,
            ),
          ),
        ),
        Visibility(visible: isLoading, child: const Loader())
      ],
    );
  }

  _loadHtmlFromAssets(_controller) async {
    String fileText = cmsPageDetail?.description ?? "";
    _controller.loadRequest(Uri.dataFromString("""<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 20; padding: 20;'>
        <div>
          $fileText
        </div>
      </body>
    </html>""", mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
    super.didChangeDependencies();
  }
}
