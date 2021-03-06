import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UrbanMed",
      theme: ThemeData(
        primarySwatch: myColour,
      ),
      home: Splash(),
    );
  }
}

const MaterialColor myColour = const MaterialColor(
  0xFFff0055,
  const <int, Color>{
    50: const Color( 0xFFff4081),
    100: const Color( 0xFFff4081),
    200: const Color( 0xFFff4081),
    300: const Color( 0xFFff4081),
    400: const Color( 0xFFff4081),
    500: const Color( 0xFFff4081),
    600: const Color( 0xFFff4081),
    700: const Color( 0xFFff4081),
    800: const Color( 0xFFff4081),
    900: const Color( 0xFFff4081),
  },
);
