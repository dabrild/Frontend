import 'package:flutter/material.dart';
import 'package:frontend_transquim/componentes/listarvehiculo.dart';
import 'package:frontend_transquim/componentes/checklist.dart';
import 'package:frontend_transquim/componentes/login.dart';
import 'package:frontend_transquim/componentes/registro.dart';
import 'package:frontend_transquim/componentes/bienvenida.dart';
import 'package:frontend_transquim/componentes/menu.dart';
//import 'package:frontend_transquim/componentes/registrovehiculo.dart';
//import 'package:frontend_transquim/componentes/iniciartransporte.dart';

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
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BienvenidaPage(),
        '/login': (context) => const LoginPage(),
        '/registro': (context) => const RegistroPage(),
        '/checklist': (context) => const ChecklistPage(),
        '/listarvehiculo': (context) => ListarVehiculosPage(),
        '/menu': (context) => const MenuPage(),
        //'/registrovehiculo': (context) => const RegistroVehiculoPage(),
        //'/iniciartransporte': (context) => const IniciarTransportePage(),
      },
    );
  }
}
