import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Screen/homepage.dart';
import 'package:weather_app/Services/location%20provider.dart';
import 'package:weather_app/Services/weather%20.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(
          create: (context) => WeatherServiceProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        )),
        home: HomeScreen(),
      ),
    );
  }
}
