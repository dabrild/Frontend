import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListarVehiculosPage extends StatefulWidget {
  const ListarVehiculosPage({super.key});

  @override
  State<ListarVehiculosPage> createState() => _ListarVehiculosPageState();
}

class _ListarVehiculosPageState extends State<ListarVehiculosPage> {
  Future<List<Map<String, dynamic>>> fetchVehiculos() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:8862/vehiculos/listar'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar vehículos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Registrados'),
        backgroundColor: const Color(0xFF0B3D91),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchVehiculos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)),
              );
            }
            final vehiculos = snapshot.data;
            if (vehiculos == null || vehiculos.isEmpty) {
              return const Center(
                child: Text('No hay vehículos registrados',
                    style: TextStyle(color: Colors.white)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final v = vehiculos[index];
                final esDisponible = (v['estado']?.toLowerCase() == 'bueno');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Licencia: ${v['licenciaTransito'] ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Placa: ${v['placa'] ?? ''}'),
                        Text('Marca: ${v['marca'] ?? ''}'),
                        Text('Color: ${v['color'] ?? ''}'),
                        Text(
                          'Tipo de Carga: ${v['tipoCarga'] ?? ''}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Estado: ${v['estado'] ?? ''}',
                          style: TextStyle(
                            color: esDisponible ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: esDisponible ? () {
                              // aquí podrías guardar la selección o navegar
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              disabledBackgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Seleccionar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('CANCELAR'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/checklist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('SIGUIENTE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

