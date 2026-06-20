import 'dart:math';
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
    
    // Generar un ID de transacción aleatorio para mayor realismo
    final txnId = 'TXN-${Random().nextInt(900000) + 100000}';
    final fecha = DateTime.now();
    final fechaStr = '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Comprobante'),
        automaticallyImplyLeading: false, // Deshabilitar retroceso para evitar re-pagos
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Tarjeta tipo Recibo
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    
                    // Icono de Estado Animado/Visual
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: aprobado 
                            ? const Color(0xFFDCFCE7) 
                            : const Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        aprobado ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 64,
                        color: aprobado ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Texto Estado
                    Text(
                      aprobado ? '¡Transacción Aprobada!' : 'Pago Rechazado',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      aprobado 
                          ? 'Tu pago se ha procesado con éxito.'
                          : 'Hubo un problema al procesar la tarjeta.',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Línea divisoria de puntos
                    Row(
                      children: List.generate(
                        150 ~/ 2.5,
                        (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : const Color(0xFFCBD5E1),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    
                    // Detalles de Transacción
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _receiptRow('ID de Pago', txnId),
                          const SizedBox(height: 12),
                          _receiptRow('Fecha y Hora', fechaStr),
                          const SizedBox(height: 12),
                          _receiptRow('Método', 'Tarjeta de Crédito'),
                          const SizedBox(height: 12),
                          _receiptRow('Estado', aprobado ? 'APROBADO' : 'RECHAZADO', 
                              textColor: aprobado ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              isStatus: true
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Botón Volver al Inicio
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A), // Slate 900
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Volver hasta la primera pantalla (MainNavigationPage)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Volver al Inicio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Botón Compartir Recibo (Simulado)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F172A),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comprobante guardado en Galería (Simulado)'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Compartir Recibo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {Color? textColor, bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: textColor?.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor ?? const Color(0xFF0F172A),
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor ?? const Color(0xFF0F172A),
            ),
          ),
      ],
    );
  }
}