import 'package:flutter/material.dart';

class ListarVehiculosPage extends StatelessWidget {
  final List<Map<String, String>> vehiculos = [
    {
      'placa': 'ABC123',
      'tipo': 'Camión',
      'capacidad': '5000 kg',
      'estado': 'Bueno',
      'disponibilidad': 'Disponible',
    },
    {
      'placa': 'XYZ789',
      'tipo': 'Furgón',
      'capacidad': '3000 kg',
      'estado': 'Bueno',
      'disponibilidad': 'Disponible',
    },
    {
      'placa': 'LMN456',
      'tipo': 'Camión',
      'capacidad': '7000 kg',
      'estado': 'En manten.',
      'disponibilidad': 'No disponible',
    },
    {
      'placa': 'DEF789',
      'tipo': 'Camión',
      'capacidad': '6000 kg',
      'estado': 'Bueno',
      'disponibilidad': 'Disponible',
    },
  ];

  ListarVehiculosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Vehículos Disponibles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(child: Text('Placa', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Capacidad', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Disponibilidad', style: TextStyle(fontWeight: FontWeight.bold))),
                              SizedBox(width: 100),
                            ],
                          ),
                          const Divider(thickness: 1),
                          ...vehiculos.map((vehiculo) {
                            final esDisponible = vehiculo['estado'] == 'Bueno';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(vehiculo['placa']!)),
                                  Expanded(child: Text(vehiculo['tipo']!)),
                                  Expanded(child: Text(vehiculo['capacidad']!)),
                                  Expanded(
                                    child: Text(
                                      vehiculo['estado']!,
                                      style: TextStyle(
                                        color: esDisponible ? Colors.green : Colors.orange,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Text(vehiculo['disponibilidad']!)),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: esDisponible ? () {} : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        disabledBackgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Seleccionar'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('CANCELAR'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/checklist');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500), // Naranja
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('SIGUIENTE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

