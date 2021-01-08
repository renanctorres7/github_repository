import 'package:flutter/material.dart';
import 'package:github_repository/home/home.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(4, 38, 76, 1),
        backgroundColor: Color.fromRGBO(4, 38, 76, 1),
        scaffoldBackgroundColor: Color.fromRGBO(4, 38, 76, 1),
      ),
      home: Home(),
    );
  }
}
