import 'package:flutter/material.dart';

import '../models/producto.dart';

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

  @override
  void dispose() {
    titularCtrl.dispose();
    tarjetaCtrl.dispose();
    expiracionCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Text(
                widget.producto.nombre,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Total: \$${widget.producto.precio}',
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: titularCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titular',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el titular';
                  }
                  return null;
                },
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
                    return 'Debe tener mínimo 16 dígitos';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: expiracionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Expiración',
                  hintText: 'MM/AA',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese fecha';
                  }
                  return null;
                },
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
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulario válido'),
                    ),
                  );
                },
                child: const Text('Pagar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}