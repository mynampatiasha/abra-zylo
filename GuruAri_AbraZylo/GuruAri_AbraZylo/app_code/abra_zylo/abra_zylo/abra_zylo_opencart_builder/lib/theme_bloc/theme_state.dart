part of 'theme_bloc.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitialState extends ThemeState {
  const ThemeInitialState({
    this.lightTheme,
    this.darkTheme,
  });

  final ThemeData? lightTheme, darkTheme;
}

class ThemeChangeState extends ThemeState {
  const ThemeChangeState({this.lightTheme, this.darkTheme});

  final ThemeData? lightTheme, darkTheme;
}
