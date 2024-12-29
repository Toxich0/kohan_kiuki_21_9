import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/tabs_screen.dart';

void main() {
  runApp(const ProviderScope(child: OwnApp()));
}

class OwnApp extends StatelessWidget {
  const OwnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uni',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const TabsScreen(),
    );
  }
}
