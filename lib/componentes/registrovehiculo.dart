import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';


class RegistrarVehiculoPage extends StatefulWidget {
  const RegistrarVehiculoPage({super.key});

  @override
  State<RegistrarVehiculoPage> createState() => _RegistrarVehiculoPageState();
}

class _RegistrarVehiculoPageState extends State<RegistrarVehiculoPage> {
  final licenciaController = TextEditingController();
  final placaController = TextEditingController();
  final marcaController = TextEditingController();
  final colorController = TextEditingController();
  final tipoCargaController = TextEditingController();

  void registrarVehiculo() async {
    final licencia = licenciaController.text.trim();
    final placa = placaController.text.trim();
    final marca = marcaController.text.trim();
    final color = colorController.text.trim();
    final tipoCarga = tipoCargaController.text.trim();

    if (licencia.isEmpty ||
        placa.isEmpty ||
        marca.isEmpty ||
        color.isEmpty ||
        tipoCarga.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.0.12:8862/vehiculos/'); // Cambia según tu IP/backend
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "licenciaTransito": licencia,
      "placa": placa,
      "marca": marca,
      "color": color,
      "estado": "Disponible", // Se puede dejar por defecto
      "tipoCarga": tipoCarga,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo registrado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar vehículo: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      appBar: AppBar(
        title: const Text('Registrar Vehículo'),
        backgroundColor: const Color(0xFF0B3D91),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: licenciaController,
                  decoration: const InputDecoration(
                    labelText: 'Licencia de Tránsito',
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: placaController,
                  decoration: const InputDecoration(
                    labelText: 'Placa',
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: marcaController,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    prefixIcon: Icon(Icons.local_shipping),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    prefixIcon: Icon(Icons.color_lens),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tipoCargaController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Carga',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: registrarVehiculo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'REGISTRAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '← Volver al menú principal',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
