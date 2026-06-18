import 'package:flutter/material.dart';
import 'package:flutter_pasarela_pago/models/pago.dart';
import '../models/producto.dart';

class ResumenPage extends StatelessWidget {
  final Producto producto;

  const ResumenPage({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Total: \$${producto.precio}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PagoPage(
          producto: producto,
        ),
      ),
    );
  },
  child: const Text(
    'Continuar al Pago',
  ),
),
          ],
        ),
      ),
    );
  }
}