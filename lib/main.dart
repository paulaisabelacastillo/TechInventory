import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => EquipoProvider()..loadEquipos(),
      child: const TechInventoryApp(),
    ),
  );
}

class TechInventoryApp extends StatelessWidget {
  const TechInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechInventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
