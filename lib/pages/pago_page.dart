import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/firebase_service.dart';
import '../services/simulador_pago.dart';
import 'resultado_page.dart';

class PagoPage extends StatefulWidget {
  final Producto producto;

  const PagoPage({
    super.key,
    required this.producto,
  });

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final formKey = GlobalKey<FormState>();

  final titularCtrl = TextEditingController();
  final tarjetaCtrl = TextEditingController();
  final expiracionCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    titularCtrl.dispose();
    tarjetaCtrl.dispose();
    expiracionCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> procesarPago() async {
    if (!formKey.currentState!.validate()) return;

    final estado = simularPago();

    await firebaseService.guardarPago(
      producto: widget.producto.nombre,
      total: widget.producto.precio,
      titular: titularCtrl.text,
      tarjeta: tarjetaCtrl.text,
      estado: estado,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoPage(estado: estado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Text(
                widget.producto.nombre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Total: \$${widget.producto.precio}',
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: titularCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del titular',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Ingrese el nombre'
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tarjetaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la tarjeta';
                  }
                  if (value.length < 16) {
                    return 'Debe tener 16 dígitos';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: expiracionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Expiración (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Ingrese fecha'
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cvvCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: procesarPago,
                child: const Text('Pagar Ahora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}