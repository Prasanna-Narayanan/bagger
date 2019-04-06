import 'package:bagger/bagger_home.dart';
import 'package:flutter/material.dart';

void main() => runApp(BagsApp());

class BagsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bagger",
      theme: ThemeData(
        primaryColor: Color(0xffffffff),
        accentColor: Color(0xffaeddcd),
        primaryIconTheme: IconThemeData(color: Color(0xff3c6382)),
        iconTheme: IconThemeData(color: Color(0xff3c6382)),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Color(0xff3c6382),
            fontFamily: "Rancho"
          ),
        ),
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: "Cookie", color: Color(0xff3c6382)),
          body2: TextStyle(fontFamily: "Cookie"),
          caption: TextStyle(fontFamily: "Cookie")
        )
      ),
      debugShowCheckedModeBanner: false,
      home: BaggerHome()
    );
  }
}