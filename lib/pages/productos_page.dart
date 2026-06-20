import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import 'resumen_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  String _selectedCategory = 'Todo';

  final List<String> _categories = ['Todo', 'Audio', 'Teclados', 'Mouses', 'Pantallas'];

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

  String _getProductCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('audífono')) return 'Audio';
    if (lower.contains('teclado')) return 'Teclados';
    if (lower.contains('mouse')) return 'Mouses';
    if (lower.contains('monitor')) return 'Pantallas';
    return 'Accesorios';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Filtrar productos según categoría elegida
    final listToShow = _selectedCategory == 'Todo'
        ? productos
        : productos.where((p) => _getProductCategory(p.nombre) == _selectedCategory).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Banner de Bienvenida
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, Explorador 👋',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nuestros Gadgets',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Color(0xFF0F172A)),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buscador simulado
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 12),
                      const Text(
                        'Buscar productos...',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Chips de categorías
            SliverToBoxAdapter(
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Grid de Productos
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              sliver: listToShow.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: const Text(
                            'No hay productos en esta categoría',
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = listToShow[index];
                          final icon = _getProductIcon(p.nombre);
                          final color = _getProductColor(p.nombre);

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagen/Icono superior
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        icon,
                                        size: 44,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                                // Textos e Información
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.nombre,
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
                                        _getProductCategory(p.nombre),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "S/ ${p.precio.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: Color(0xFF6366F1),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ResumenPage(producto: p),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF0F172A),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.chevron_right_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: listToShow.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}