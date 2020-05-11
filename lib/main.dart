import 'package:flutter/material.dart';
import 'package:flutter_sqlite_example_avdisx/screen/home_page.dart';

/* Code by avdisx */
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HOMEPAGE(),
    );
  }
}
