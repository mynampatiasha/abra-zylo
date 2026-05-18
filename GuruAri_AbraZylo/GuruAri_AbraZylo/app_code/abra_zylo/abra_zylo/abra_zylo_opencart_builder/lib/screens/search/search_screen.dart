import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';
import 'package:oc_demo/screens/search/views/search_category_suggestion.dart';
import 'package:oc_demo/screens/search/views/search_suggestion.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/dialog_helper.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../utils/helper.dart';
import 'bloc/search_bloc.dart';
import 'bloc/search_events.dart';
import 'bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
//  bool isFirst = true;
  SearchModel? searchData;
  TextEditingController textEditingController = TextEditingController();
  SearchScreenBloc? searchScreenBloc;
  AppLocalizations? _localizations;
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String transcription = '';
  String selectedLang = "en_US";
  Timer? _debounce;

  @override
  void initState() {
    activateSpeechRecognizer();
    AppSharedPref.getLanguage().then((value) => selectedLang = value);
    searchScreenBloc = context.read<SearchScreenBloc>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  void activateSpeechRecognizer() async {
    await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _isListening = true;
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      transcription = result.recognizedWords;
      textEditingController.text = transcription;
      searchScreenBloc?.add(SearchSuggestionEvent(transcription));
      _stopListening();
    });
  }

  void errorHandler() => activateSpeechRecognizer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchScreenBloc, SearchState>(
        builder: (context, currentState) {
      print(currentState);
      if (currentState is SearchInitialState) {
        /*   if (!isFirst) {
          isLoading = true;
        }
        isFirst = false;*/
      } else if (currentState is SearchScreenSuccess) {
        searchData = currentState.model;
        isLoading = false;
        searchScreenBloc?.emit(SearchActionState());
      } else if (currentState is SearchScreenError) {
        isLoading = false;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message, context);
        });
      }
      return _buildUI();
    });
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
            readOnly: _isListening,
            controller: textEditingController,
            onChanged: (searchKey) {
              isLoading = true;
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(Duration(seconds: 1), () {
                searchScreenBloc?.add(SearchSuggestionEvent(searchKey));
              });
              print("Search key ---> " + searchKey);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  _localizations?.translate(AppStringConstant.search) ?? '',
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
          actions: [
            (_isListening)
                ? Center(
                    child: Text(
                        _localizations
                                ?.translate(AppStringConstant.listening) ??
                            '',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.normal)))
                : IconButton(
                    onPressed: () {
                      DialogHelper.searchDialog(context, _localizations, () {
                        startImageRecognition(searchImage);
                      }, () {
                        startImageRecognition(searchText);
                      });
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
            textEditingController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Helper.hideSoftKeyBoard();
                      textEditingController.text = "";
                      searchScreenBloc?.add(InitialSearchSuggestionEvent());
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
                : IconButton(
                    onPressed:
                        // If not yet listening for speech start, otherwise stop
                        _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                    icon: Icon(
                      (_isListening) ? Icons.hearing_sharp : Icons.mic,
                    ),
                  )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(
                  backgroundColor: AppColors.black,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.size16,
                    AppSizes.size16, AppSizes.size16, AppSizes.size8),
                child: Text(
                  _localizations?.translate(AppStringConstant.categories) ?? "",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              getSearchCategorySuggestion(GlobalData.rootCategories),
              Visibility(
                visible: !isLoading,
                child: ((searchData?.searchData ?? []).isNotEmpty)
                    ? suggestionList(
                        context, _localizations, searchData?.searchData)
                    : Padding(
                        padding: const EdgeInsets.all(AppSizes.size8),
                        child: Center(
                          child: Text(_localizations
                                  ?.translate(AppStringConstant.noResult) ??
                              ''),
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  String searchImage = "imageSearch";
  String searchText = "textSearch";
  var methodChannel = const MethodChannel(AppConstant.channelName);

  Future<String> startImageRecognition(String type) async {
    try {
      String data = await methodChannel.invokeMethod(type);
      Navigator.pop(context);
      textEditingController.text = data;
      isLoading = true;
      searchScreenBloc?.add(SearchSuggestionEvent(data));
      // searchScreenBloc?.emit(SearchInitialState());
      return data;
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
