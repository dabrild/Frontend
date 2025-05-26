import 'package:flutter/material.dart';
import 'dart:async';
import 'OrdenTrabajo.dart'; //
import 'ListarOrdenTrabajo.dart'; // Agregar esta importación

// Variables globales para el cronómetro
DateTime? _tiempoInicio;
DateTime? _tiempoFin;
bool _cronometroActivo = false;

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú Principal',
          style: TextStyle(
            color: Colors.white, // Texto blanco explícitamente
          ),
        ),
        backgroundColor: const Color(0xFF0B3D91),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white), // Asegura íconos blancos también
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/registrovehiculo');
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar Vehículo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/listarvehiculo');
              },
              icon: const Icon(Icons.list),
              label: const Text('Listado de Vehículos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdenTrabajoPage()),
                );
              },
              icon: const Icon(Icons.assignment),
              label: const Text('Registrar Orden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListarOrdenTrabajoPage()),
                );
              },
              icon: const Icon(Icons.format_list_bulleted),
              label: const Text('Listado de Órdenes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Iniciar cronómetro
                _tiempoInicio = DateTime.now();
                _cronometroActivo = true;
                _tiempoFin = null;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transporte iniciado'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.local_shipping),
              label: const Text('Iniciar Transporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Finalizar cronómetro
                if (_cronometroActivo) {
                  _tiempoFin = DateTime.now();
                  _cronometroActivo = false;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transporte finalizado', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.flag),
              label: const Text('Finalizar Transporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            // Reloj y cronómetro lado a lado
            Expanded(
              child: Row(
                children: [
                  // Reloj simple - solo números
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            final now = DateTime.now();
                            final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
                            return Text(
                              timeString,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily: 'monospace',
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Módulo de cronómetro
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          // Formatear hora de inicio
                          String horaInicio = '--:--:--';
                          if (_tiempoInicio != null) {
                            horaInicio = '${_tiempoInicio!.hour.toString().padLeft(2, '0')}:${_tiempoInicio!.minute.toString().padLeft(2, '0')}:${_tiempoInicio!.second.toString().padLeft(2, '0')}';
                          }

                          // Formatear hora de fin
                          String horaFin = '--:--:--';
                          if (_tiempoFin != null) {
                            horaFin = '${_tiempoFin!.hour.toString().padLeft(2, '0')}:${_tiempoFin!.minute.toString().padLeft(2, '0')}:${_tiempoFin!.second.toString().padLeft(2, '0')}';
                          }

                          // Calcular tiempo transcurrido
                          String tiempoTranscurrido = '00:00:00';
                          if (_tiempoInicio != null) {
                            DateTime referencia = _cronometroActivo ? DateTime.now() : (_tiempoFin ?? DateTime.now());
                            Duration diferencia = referencia.difference(_tiempoInicio!);
                            int horas = diferencia.inHours;
                            int minutos = diferencia.inMinutes.remainder(60);
                            int segundos = diferencia.inSeconds.remainder(60);
                            tiempoTranscurrido = '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tiempo de Transporte',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Inicio: $horaInicio',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Fin: $horaFin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tiempoTranscurrido,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _cronometroActivo ? Colors.green.shade600 : Colors.red.shade600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Finalizar Sesión', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}