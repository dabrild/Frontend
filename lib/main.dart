import 'package:flutter/material.dart';
import 'componentes/login.dart';
import 'componentes/registro.dart';

void main() {
  runApp(const TransQuimApp());
}

class TransQuimApp extends StatelessWidget {
  const TransQuimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransQuim App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/registro': (context) => const RegistroPage(),
      },
    );
  }
}
