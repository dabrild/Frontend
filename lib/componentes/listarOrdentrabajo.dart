import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarOrdenTrabajoPage extends StatefulWidget {
  const ListarOrdenTrabajoPage({super.key});

  @override
  State<ListarOrdenTrabajoPage> createState() => _ListarOrdenTrabajoPageState();
}

class _ListarOrdenTrabajoPageState extends State<ListarOrdenTrabajoPage> {
  List<Map<String, dynamic>> ordenes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarOrdenes();
  }

  Future<void> _cargarOrdenes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.12:8862/OrdenTransporte/obtener'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          ordenes = data.map((orden) => Map<String, dynamic>.from(orden)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar órdenes: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  String _formatearFecha(String? fechaStr) {
    if (fechaStr == null) return 'No especificada';
    try {
      DateTime fecha = DateTime.parse(fechaStr);
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  Color _getColorEstado(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'asignada':
        return Colors.blue;
      case 'en camino':
        return Colors.orange;
      case 'entregada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _mostrarDetallesOrden(Map<String, dynamic> orden) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Orden #${orden['numeroOrden']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetalleFila('Cliente:', orden['nombreCliente'] ?? 'No especificado'),
                _buildDetalleFila('Teléfono:', orden['telefonoContacto']?.toString() ?? 'No especificado'),
                _buildDetalleFila('Email:', orden['emailContacto'] ?? 'No especificado'),
                _buildDetalleFila('Fecha Asignación:', _formatearFecha(orden['fechaAsignacion'])),
                _buildDetalleFila('Dirección Recogida:', orden['direccionRecogida'] ?? 'No especificada'),
                _buildDetalleFila('Dirección Entrega:', orden['direccionEntrega'] ?? 'No especificada'),
                _buildDetalleFila('Tipo Sustancia:', orden['tipoSustancia'] ?? 'No especificado'),
                _buildDetalleFila('Cantidad:', '${orden['cantidad'] ?? 'No especificada'} ${orden['unidadMedida'] ?? ''}'),
                _buildDetalleFila('Tipo Vehículo:', orden['tipoVehiculo'] ?? 'No especificado'),
                _buildDetalleFila('Tiempo Estimado:', _formatearFecha(orden['tiempoEstimadoEntrega'])),
                _buildDetalleFila('ID Conductor:', orden['idConductor']?.toString() ?? 'No asignado'),
                _buildDetalleFila('ID Vehículo:', orden['idVehiculo']?.toString() ?? 'No asignado'),
                if (orden['observaciones'] != null && orden['observaciones'].toString().isNotEmpty)
                  _buildDetalleFila('Observaciones:', orden['observaciones']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetalleFila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/menu',
                            (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Órdenes de Trabajo Registradas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _cargarOrdenes,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : errorMessage != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarOrdenes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                    : ordenes.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay órdenes de trabajo registradas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Las órdenes de trabajo que registres aparecerán aquí',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: ordenes.length,
                  itemBuilder: (context, index) {
                    final orden = ordenes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Encabezado de la orden
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Orden: ${orden['numeroOrden']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getColorEstado(orden['estadoEntrega']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  orden['estadoEntrega'] ?? 'Sin estado',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Información principal
                          _buildInfoRow('Cliente:', orden['nombreCliente']),
                          _buildInfoRow('Teléfono:', orden['telefonoContacto']?.toString()),
                          _buildInfoRow('Recogida:', orden['direccionRecogida']),
                          _buildInfoRow('Entrega:', orden['direccionEntrega']),
                          _buildInfoRow('Fecha:', _formatearFecha(orden['fechaAsignacion'])),

                          const SizedBox(height: 20),

                          // Botón de acción
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => _mostrarDetallesOrden(orden),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'Ver Detalles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Botón Cancelar
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'No especificado',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}