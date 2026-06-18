import 'package:flutter/material.dart';

import '../data/productos_data.dart';
import 'resumen_page.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto =
              productos[index];

          return Card(
            margin:
                const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                producto.nombre,
              ),
              subtitle: Text(
                '\$${producto.precio}',
              ),
              trailing:
                  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ResumenPage(
                        producto:
                            producto,
                      ),
                    ),
                  );
                },
                child:
                    const Text('Comprar'),
              ),
            ),
          );
        },
      ),
    );
  }
}