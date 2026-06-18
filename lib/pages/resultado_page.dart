import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final String estado;

  const ResultadoPage({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final aprobado = estado == 'APROBADO';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              aprobado
                  ? Icons.check_circle
                  : Icons.cancel,
              size: 100,
              color: aprobado
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              estado,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}