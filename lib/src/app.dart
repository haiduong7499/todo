import 'package:do_an/screen/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: HomeScreen(),
    );
  }
}
ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    primaryColor: Color(0xff38044B),
    accentColor: Color(0xff38044B),
    buttonColor: Color(0xff38044B), 
    splashColor: Color(0xff38044B),
    primaryTextTheme: buildTextTheme(base.primaryTextTheme, Color(0xff38044B)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff38044B))
      ),
      labelStyle: TextStyle(
        color: Color(0xff38044B),
      ),
    ),
  );
}
TextTheme buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    body1: base.headline.copyWith(color: color),
    caption: base.headline.copyWith(color: color),
    display1: base.headline.copyWith(color: color),
    button: base.headline.copyWith(color: color),
    headline: base.headline.copyWith(color: color),
    title: base.title.copyWith(color: color),
  );
}
