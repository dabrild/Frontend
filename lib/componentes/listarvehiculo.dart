import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListarVehiculosPage extends StatefulWidget {
  const ListarVehiculosPage({super.key});

  @override
  State<ListarVehiculosPage> createState() => _ListarVehiculosPageState();
}

class _ListarVehiculosPageState extends State<ListarVehiculosPage> {
  Map<String, dynamic>? _vehiculoSeleccionado;

  Future<List<Map<String, dynamic>>> fetchVehiculos() async {
    final response = await http.get(Uri.parse('http://192.168.0.12:8862/vehiculos/listar'));

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/menu',
                  (route) => false,
            );
          },
        ),
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
                final esDisponible = (v['estado']?.toLowerCase() == 'disponible');
                final esteVehiculoSeleccionado = _vehiculoSeleccionado != null &&
                    _vehiculoSeleccionado!['licenciaTransito'] == v['licenciaTransito'];

                // Determinar si este vehículo debe estar deshabilitado
                final hayVehiculoSeleccionado = _vehiculoSeleccionado != null;
                final vehiculoDeshabilitado = hayVehiculoSeleccionado && !esteVehiculoSeleccionado;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  // Cambiar color de fondo según el estado
                  color: esteVehiculoSeleccionado
                      ? Colors.grey.shade300
                      : vehiculoDeshabilitado
                      ? Colors.grey.shade100
                      : Colors.white,
                  child: Opacity(
                    // Reducir opacidad de vehículos deshabilitados
                    opacity: vehiculoDeshabilitado ? 0.5 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Licencia: ${v['licenciaTransito'] ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: vehiculoDeshabilitado ? Colors.grey : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Placa: ${v['placa'] ?? ''}',
                            style: TextStyle(
                              color: vehiculoDeshabilitado ? Colors.grey : Colors.black,
                            ),
                          ),
                          Text(
                            'Marca: ${v['marca'] ?? ''}',
                            style: TextStyle(
                              color: vehiculoDeshabilitado ? Colors.grey : Colors.black,
                            ),
                          ),
                          Text(
                            'Color: ${v['color'] ?? ''}',
                            style: TextStyle(
                              color: vehiculoDeshabilitado ? Colors.grey : Colors.black,
                            ),
                          ),
                          Text(
                            'Tipo de Carga: ${v['tipoCarga'] ?? ''}',
                            style: TextStyle(
                              color: vehiculoDeshabilitado ? Colors.grey : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // Si está seleccionado, mostrar "No disponible", sino el estado original
                            'Estado: ${esteVehiculoSeleccionado ? 'No disponible' : (v['estado'] ?? '')}',
                            style: TextStyle(
                              // Si está seleccionado, color rojo, sino el color según disponibilidad
                              color: esteVehiculoSeleccionado
                                  ? Colors.red
                                  : vehiculoDeshabilitado
                                  ? Colors.grey
                                  : (esDisponible ? Colors.green : Colors.orange),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: esteVehiculoSeleccionado
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _vehiculoSeleccionado = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Selección cancelada'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancelar'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Seleccionado ✓'),
                                ),
                              ],
                            )
                                : ElevatedButton(
                              onPressed: (esDisponible && !vehiculoDeshabilitado)
                                  ? () {
                                setState(() {
                                  _vehiculoSeleccionado = v;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Vehículo seleccionado'),
                                  ),
                                );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                disabledBackgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                  vehiculoDeshabilitado
                                      ? 'No disponible'
                                      : 'Seleccionar'
                              ),
                            ),
                          ),
                        ],
                      ),
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
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/menu',
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                onPressed: _vehiculoSeleccionado == null
                    ? null
                    : () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/checklist',
                    arguments: _vehiculoSeleccionado,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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