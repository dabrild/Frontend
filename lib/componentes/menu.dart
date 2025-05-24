import 'package:flutter/material.dart';
// Agregar solo esta línea al inicio del archivo
import 'OrdenTrabajo.dart'; // Ajusta la ruta según donde tengas el archivo

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
                // ÚNICO CAMBIO: Reemplazar esta línea
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdenTrabajoPage()),
                );
              },
              icon: const Icon(Icons.local_shipping),
              label: const Text('Iniciar Transporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Finalizar Sesión'),
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