part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class ThemeChangeEvent extends ThemeEvent {
  const ThemeChangeEvent({this.darkTheme, this.lightTheme});

  final ThemeData? lightTheme, darkTheme;
}
