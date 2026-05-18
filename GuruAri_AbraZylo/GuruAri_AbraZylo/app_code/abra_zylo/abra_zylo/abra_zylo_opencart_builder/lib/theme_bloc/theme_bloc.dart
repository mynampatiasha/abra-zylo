import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeInitialState(
          lightTheme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        )) {
    on(mapEventToState);
  }

  void mapEventToState(ThemeEvent event, Emitter<ThemeState> emit) {
    if (event is ThemeChangeEvent) {
      emit(ThemeChangeState(
        lightTheme: event.lightTheme,
        darkTheme: event.darkTheme,
      ));
    }
  }
}
