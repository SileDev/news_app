import 'package:flutter/material.dart';
import 'package:news_app/ui/screens/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: Colors.indigo,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xffffffff),
          onPrimary: Color(0xffffffff),
          secondary: Color(0xff17b070),
          onSecondary: Color(0xffefefef),
          error: Color(0xffba1b1b),
          onError: Color(0xffefefef),
          background: Color(0xffdfdfdf),
          onBackground: Color(0xff1f1f1f),
          surface: Color(0xff303030),
          onSurface: Color(0xffefefef),
        ),
      ),
      home: const HomePage(),
    );
  }
}
