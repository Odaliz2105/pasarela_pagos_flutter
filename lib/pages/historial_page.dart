import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  String _selectedFilter = 'Todos';

  IconData _getProductIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('audífono') || lower.contains('auricular') || lower.contains('bluetooth')) {
      return Icons.headphones_rounded;
    } else if (lower.contains('teclado')) {
      return Icons.keyboard_rounded;
    } else if (lower.contains('mouse')) {
      return Icons.mouse_rounded;
    } else if (lower.contains('monitor') || lower.contains('pantalla')) {
      return Icons.desktop_windows_rounded;
    }
    return Icons.shopping_bag_rounded;
  }

  Color _getProductColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('audífono')) return const Color(0xFF6366F1); // Indigo
    if (lower.contains('teclado')) return const Color(0xFFEC4899); // Pink
    if (lower.contains('mouse')) return const Color(0xFF14B8A6); // Teal
    if (lower.contains('monitor')) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFF3B82F6); // Blue
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Historial de Pagos"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filtros de estado
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFilterChip('Todos'),
                    _buildFilterChip('Aprobados'),
                    _buildFilterChip('Rechazados'),
                  ],
                ),
              ),
            ),
            
            // Lista de transacciones
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('pagos_simulados')
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          "Error al cargar transacciones. Asegúrate de configurar los índices de Firestore si es necesario.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF475569)),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                    );
                  }

                  var docs = snapshot.data!.docs;

                  // Filtrar en memoria para evitar errores de índices compuestos en Firestore
                  if (_selectedFilter == 'Aprobados') {
                    docs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['estado'] == 'APROBADO';
                    }).toList();
                  } else if (_selectedFilter == 'Rechazados') {
                    docs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['estado'] == 'RECHAZADO';
                    }).toList();
                  }

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No hay pagos registrados",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Los pagos que realices aparecerán aquí.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final estado = data['estado'] ?? 'RECHAZADO';
                      final aprobado = estado == 'APROBADO';
                      final producto = data['producto'] ?? 'Producto';
                      final total = (data['total'] as num?)?.toDouble() ?? 0.0;
                      final titular = data['titular'] ?? 'Titular';
                      final ultimos4 = data['ultimos4'] ?? '••••';
                      final fechaRaw = data['fecha'] as Timestamp?;
                      
                      String fechaStr = '';
                      if (fechaRaw != null) {
                        final date = fechaRaw.toDate();
                        fechaStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                      }

                      final icon = _getProductIcon(producto);
                      final color = _getProductColor(producto);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            // Icono del Producto con fondo suave
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                icon,
                                color: color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            
                            // Detalles centrales
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tarjeta •••• $ultimos4 | $titular',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fechaStr,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Monto y Estado a la derecha
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'S/ ${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: aprobado 
                                        ? const Color(0xFFDCFCE7) 
                                        : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    aprobado ? 'Aprobado' : 'Rechazado',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: aprobado ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
            });
          }
        },
        selectedColor: const Color(0xFF0F172A),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF475569),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
        showCheckmark: false,
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }
}