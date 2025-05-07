import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => ChecklistPageState();
}

class ChecklistPageState extends State<ChecklistPage> {
  final List<String> items = [
    'Manual de fugas y derrames',
    'Botiquín de primeros auxilios',
    'Elementos de protección personal',
    'Documentación mercancías peligrosas vigente',
    'Certificación manejo de incendios',
    'Tipo de químico',
    'Cantidad de químico',
    'Manifiestos de carga',
    'SOAT',
    'Tecnomecánica',
    'Seguro',
    'Tipo de carga',
    'Tipo de vehículo',
    'Licencia',
  ];

  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.filled(items.length, false);
  }

  Future<void> enviarChecklist() async {
    final url = Uri.parse('http://192.168.142.129:8862/Checklist/');

    final Map<String, dynamic> data = {
      'licencia': 12345678,
      'manualFugasDerrames': checked[0] ? 'Sí' : 'No',
      'botiquinPrimerosAuxilios': checked[1] ? 'Sí' : 'No',
      'elementosProteccionPersonal': checked[2] ? 'Sí' : 'No',
      'documentacionVigenteMercanciasPeligrosas': checked[3] ? 'Sí' : 'No',
      'certificacionManejoIncendios': checked[4] ? 'Sí' : 'No',
      'tipoQuimico': checked[5] ? 'Cloroformo' : 'Otro',
      'cantidadQuimico': checked[6] ? 200 : 0,
      'manifiestosCarga': checked[7] ? 'Sí' : 'No',
      'soat': checked[8] ?  'Sí' : 'No',
      'tecnomecanica': checked[9] ? 'Sí' : 'No',
      'seguro': checked[10] ? 'Sí' : 'No',
      'tipoCarga': checked[11] ? 'Carga peligrosa' : 'Otra',
      'tipoVehiculo': checked[12] ? 'Camión' : 'Otro',
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/bienvenida');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error al enviar checklist: ${response.statusCode}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'CHECKLIST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Revisión de elementos esenciales',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(items[index]),
                      value: checked[index],
                      onChanged: (value) {
                        setState(() {
                          checked[index] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: enviarChecklist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Volver al inicio'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Gestión eficiente y normativa',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
