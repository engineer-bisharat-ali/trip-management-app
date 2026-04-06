import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_management/providers/trip_provider.dart';
import 'package:trip_management/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Providing TripProvider to the entire app
      providers: [ChangeNotifierProvider(create: (_) => TripProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trip App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
