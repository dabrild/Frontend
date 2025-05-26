import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_transquim/componentes/OrdenTrabajo.dart';
import 'package:http/http.dart' as http;

class AsignacionVehiculoPage extends StatefulWidget {
  const AsignacionVehiculoPage({super.key});

  @override
  State<AsignacionVehiculoPage> createState() => _AsignacionVehiculoPageState();
}

class _AsignacionVehiculoPageState extends State<AsignacionVehiculoPage> {
  final TextEditingController _licenciaController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  bool _isLoading = false;

  Future<List<Map<String, dynamic>>> fetchVehiculos() async {
    final response = await http.get(Uri.parse('http://192.168.0.12:8862/vehiculos/listar'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar vehículos');
    }
  }

  Future<void> asignarConductor() async {
    if (_licenciaController.text.isEmpty || _cedulaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.12:8862/vehiculos/asignar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'licenciaTransito': int.parse(_licenciaController.text),
          'cedulaConductor': int.parse(_cedulaController.text),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conductor asignado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _licenciaController.clear();
        _cedulaController.clear();
        setState(() {}); // Recargar datos
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Conductor'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Formulario de asignación
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Asignar Conductor a Vehículo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _licenciaController,
                        decoration: const InputDecoration(
                          labelText: 'Licencia de Tránsito',
                          hintText: 'Ejemplo: 12345',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                          labelText: 'Cédula del Conductor',
                          hintText: 'Ejemplo: 123456789',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : asignarConductor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA500),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'ASIGNAR CONDUCTOR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Lista de vehículos disponibles
              const Text(
                'Vehículos Disponibles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchVehiculos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    final vehiculos = snapshot.data;
                    if (vehiculos == null || vehiculos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay vehículos registrados',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: vehiculos.length,
                      itemBuilder: (context, index) {
                        final v = vehiculos[index];
                        final tieneConductor = v['conductor'] != null;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              tieneConductor ? Icons.person : Icons.directions_car,
                              color: tieneConductor ? Colors.green : Colors.orange,
                            ),
                            title: Text('Licencia: ${v['licenciaTransito']}'),
                            subtitle: Text(
                              'Placa: ${v['placa']} - Marca: ${v['marca']}\n'
                                  'Estado: ${tieneConductor ? 'Con conductor asignado' : 'Sin conductor'}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.input),
                                  onPressed: () {
                                    _licenciaController.text = v['licenciaTransito'].toString();
                                  },
                                ),
                                // AGREGAR SOLO ESTE BOTÓN:
                                ElevatedButton(
                                  onPressed: () {
                                    // Navegar a OrdenTrabajoPage con el vehículo seleccionado
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const OrdenTrabajoPage(),
                                        settings: RouteSettings(arguments: v),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  child: const Text(
                                    'SELECCIONAR',
                                    style: TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            tileColor: tieneConductor ? Colors.green.shade50 : null,

                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          child: const Text('VOLVER AL MENÚ'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _licenciaController.dispose();
    _cedulaController.dispose();
    super.dispose();
  }
}