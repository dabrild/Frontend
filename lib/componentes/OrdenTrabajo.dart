import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class OrdenTrabajoPage extends StatefulWidget {
  const OrdenTrabajoPage({super.key});

  @override
  State<OrdenTrabajoPage> createState() => _OrdenTrabajoPageState();
}

class _OrdenTrabajoPageState extends State<OrdenTrabajoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers para los campos del formulario
  final _numeroOrdenController = TextEditingController();
  final _nombreClienteController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionRecogidaController = TextEditingController();
  final _direccionEntregaController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _idConductorController = TextEditingController();
  final _idVehiculoController = TextEditingController();

  @override
  void dispose() {
    _numeroOrdenController.dispose();
    _nombreClienteController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionRecogidaController.dispose();
    _direccionEntregaController.dispose();
    _observacionesController.dispose();
    _idConductorController.dispose();
    _idVehiculoController.dispose();
    super.dispose();
  }

  Future<void> _registrarOrden() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final orden = {
        'numeroOrden': int.tryParse(_numeroOrdenController.text),
        'fechaAsignacion': DateTime.now().toIso8601String(),
        'direccionRecogida': _direccionRecogidaController.text,
        'direccionEntrega': _direccionEntregaController.text,
        'tiempoEstimadoEntrega': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'observaciones': _observacionesController.text,
        'nombreCliente': _nombreClienteController.text,
        'telefonoContacto': int.tryParse(_telefonoController.text),
        'emailContacto': _emailController.text,
        'idConductor': int.tryParse(_idConductorController.text) ?? 1,
        'idVehiculo': int.tryParse(_idVehiculoController.text) ?? 1,
      };

      final response = await http.post(
        Uri.parse('http://192.168.0.12:8862/OrdenTransporte/crear'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orden),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orden registrada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Limpiar formulario
        _formKey.currentState!.reset();
        _numeroOrdenController.clear();
        _nombreClienteController.clear();
        _telefonoController.clear();
        _emailController.clear();
        _direccionRecogidaController.clear();
        _direccionEntregaController.clear();
        _observacionesController.clear();
        _idConductorController.clear();
        _idVehiculoController.clear();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar orden: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
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
        title: const Text(
          'Registrar Orden de Trabajo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0B3D91),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Número de Orden
                    TextFormField(
                      controller: _numeroOrdenController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.confirmation_number),
                        hintText: 'Número de Orden',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el número de orden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nombre Cliente
                    TextFormField(
                      controller: _nombreClienteController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Nombre del Cliente',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el nombre del cliente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Teléfono
                    TextFormField(
                      controller: _telefonoController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'Teléfono de Contacto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Email de Contacto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Dirección de Recogida
                    TextFormField(
                      controller: _direccionRecogidaController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        hintText: 'Dirección de Recogida',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dirección de Entrega
                    TextFormField(
                      controller: _direccionEntregaController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.my_location),
                        hintText: 'Dirección de Entrega',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ID Conductor
                    TextFormField(
                      controller: _idConductorController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge),
                        hintText: 'ID Conductor',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // ID Vehículo
                    TextFormField(
                      controller: _idVehiculoController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.directions_car),
                        hintText: 'ID Vehículo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Observaciones
                    TextFormField(
                      controller: _observacionesController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.note),
                        hintText: 'Observaciones',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),

                    // Botón Registrar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _registrarOrden,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'REGISTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botón Volver al menú
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/menu',
                              (route) => false,
                        );
                      },
                      child: const Text(
                        '← Volver al menú principal',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}