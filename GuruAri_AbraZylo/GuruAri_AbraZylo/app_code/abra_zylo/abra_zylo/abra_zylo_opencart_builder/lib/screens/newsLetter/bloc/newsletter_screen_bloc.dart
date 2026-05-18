import 'package:bloc/bloc.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsLetter_screen_state.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsletter_screen_event.dart';
import 'package:oc_demo/screens/newsLetter/bloc/newsletter_screen_repository.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_repository.dart';
import 'package:oc_demo/screens/notifications/bloc/notification_screen_state.dart';
import 'package:oc_demo/screens/notifications/bloc/splash_screen_event.dart';

class NewsLetterScreenBloc
    extends Bloc<NewsLetterScreenEvent, NewsLetterScreenState> {
  NewsLetterScreenRepository? repository;
  static const String Tag = "NewsLetterScreenBloc:- ";

  NewsLetterScreenBloc({this.repository}) : super(NewsLetterScreenInitial()) {
    on<NewsLetterScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(
      NewsLetterScreenEvent event, Emitter<NewsLetterScreenState> emit) async {
    if (event is GetNewsLetterEvent) {
      try {
        var model = await repository?.getNewsLetter();
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(GetNewsLetterSuccess(model));
        } else {
          print(Tag + " api login_signup Fail");
          emit(NewsLetterScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(NewsLetterScreenError(error.toString()));
      }
    }
    if (event is SetNewsLetterEvent) {
      try {
        var model = await repository?.setNewsLetter(event.newsLetter);
        if (model != null && model.error != 1) {
          print(Tag + " success ");
          emit(NewsLetterScreenSuccess(model));
        } else {
          print(Tag + " api login_signup Fail");
          emit(NewsLetterScreenError(''));
        }
      } catch (error, _) {
        print(Tag + " Exception " + error.toString());
        emit(NewsLetterScreenError(error.toString()));
      }
    }
  }
}
