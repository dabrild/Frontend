import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => ChecklistPageState();
}

class ChecklistPageState extends State<ChecklistPage> {
  late List<bool> checked;
  Map<String, dynamic>? vehiculoSeleccionado;

  // Items base del checklist
  final List<String> itemsBase = [
    'Manual de fugas y derrames',
    'Botiquín de primeros auxilios',
    'Elementos de protección personal',
    'Documentación mercancías peligrosas vigente',
    'Certificación manejo de incendios',
    'SOAT',
    'Tecnomecánica',
    'Seguro',
    'Licencia',
    'Manifiestos de carga',
  ];

  List<String> getItemsCompletos() {
    List<String> items = List.from(itemsBase);

    if (vehiculoSeleccionado != null) {
      // Agregar información específica del vehículo
      items.add('Carga transportada: ${vehiculoSeleccionado!['tipoCarga']}');

      // Agregar verificaciones específicas según el tipo de carga
      String tipoCarga = vehiculoSeleccionado!['tipoCarga']?.toLowerCase() ?? '';

      if (tipoCarga.contains('quimico') || tipoCarga.contains('agua')) {
        items.add('Verificación de contenedores sellados');
        items.add('Etiquetas de identificación del químico');
        items.add('Equipo de contención de derrames');
      }

      if (tipoCarga.contains('combustible') || tipoCarga.contains('gasolina')) {
        items.add('Verificación de tanques sin fugas');
        items.add('Equipo contra incendios especializado');
        items.add('Señalización de material inflamable');
      }
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    // La inicialización del checked se hará en didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Obtener el vehículo seleccionado una sola vez
    if (vehiculoSeleccionado == null) {
      vehiculoSeleccionado = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      // Inicializar la lista de checked después de obtener el vehículo
      List<String> items = getItemsCompletos();
      checked = List.filled(items.length, false);
    }
  }

  bool todosLosItemsCheckeados() {
    return checked.every((item) => item == true);
  }

  void mostrarDialogoConfirmacion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Checklist'),
          content: Text(
              todosLosItemsCheckeados()
                  ? 'Todos los elementos han sido verificados. ¿Desea confirmar el checklist?'
                  : 'Aún hay elementos sin verificar. ¿Está seguro de continuar?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí podrías enviar los datos al backend
                confirmarChecklist();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void confirmarChecklist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checklist confirmado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    // Ir al menú principal
    Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = getItemsCompletos();

    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
              const SizedBox(height: 30),

              // Información del vehículo seleccionado
              if (vehiculoSeleccionado != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Vehículo Seleccionado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Placa:',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '${vehiculoSeleccionado!['placa']}',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Marca:',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '${vehiculoSeleccionado!['marca']}',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tipo de Carga:',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '${vehiculoSeleccionado!['tipoCarga']}',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Licencia:',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '${vehiculoSeleccionado!['licenciaTransito']}',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],

              // Indicador de progreso
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Completado: ${checked.where((item) => item).length}/${items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Lista de checklist
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: checked[index] ? Colors.green.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: checked[index] ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: checked[index] ? Colors.green.shade700 : Colors.black87,
                            fontWeight: checked[index] ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                        value: checked[index],
                        onChanged: (value) {
                          setState(() {
                            checked[index] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: mostrarDialogoConfirmacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: todosLosItemsCheckeados() ? Colors.green : Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        todosLosItemsCheckeados() ? 'COMPLETADO' : 'CONFIRMAR',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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