import 'package:flutter/material.dart';
import 'tela_planetas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Planetas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanetListScreen(),
    );
  }
}