
import 'package:flutter/material.dart';
import 'package:tareas_application_1/screens/home_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Tareas App',
      debugShowCheckedModeBanner: false,
      home:const ListaStreams(),
    );
  }
}
