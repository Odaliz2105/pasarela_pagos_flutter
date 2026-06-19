import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('pagos_simulados').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          int totalPagos = docs.length;
          int aprobados = 0;
          int rechazados = 0;
          double totalDinero = 0;

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;

            final estado = data['estado'];
            final total = (data['total'] as num).toDouble();

            totalDinero += total;

            if (estado == 'APROBADO') {
              aprobados++;
            } else {
              rechazados++;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // 📊 TARJETAS
                Row(
                  children: [
                    _card("Pagos", totalPagos.toString(), Colors.blue),
                    const SizedBox(width: 10),
                    _card("Total S/", totalDinero.toStringAsFixed(2), Colors.green),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _card("Aprobados", aprobados.toString(), Colors.green),
                    const SizedBox(width: 10),
                    _card("Rechazados", rechazados.toString(), Colors.red),
                  ],
                ),

                const SizedBox(height: 20),

                // 📊 BARRA SIMPLE VISUAL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Estado de Pagos",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      LinearProgressIndicator(
                        value: totalPagos == 0
                            ? 0
                            : aprobados / totalPagos,
                        backgroundColor: Colors.red.shade200,
                        color: Colors.green,
                        minHeight: 10,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${(totalPagos == 0 ? 0 : (aprobados / totalPagos * 100)).toStringAsFixed(1)}% aprobados",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}