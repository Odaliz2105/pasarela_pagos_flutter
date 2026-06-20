import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/producto.dart';
import '../services/firebase_service.dart';
import '../services/simulador_pago.dart';
import 'resultado_page.dart';

// --- Formateadores de entrada personalizados ---
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

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

  final FocusNode cvvFocusNode = FocusNode();
  bool _showBack = false;

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    cvvFocusNode.addListener(_onCvvFocusChange);
  }

  void _onCvvFocusChange() {
    setState(() {
      _showBack = cvvFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    titularCtrl.dispose();
    tarjetaCtrl.dispose();
    expiracionCtrl.dispose();
    cvvCtrl.dispose();
    cvvFocusNode.removeListener(_onCvvFocusChange);
    cvvFocusNode.dispose();
    super.dispose();
  }

  Future<void> procesarPago() async {
    if (!formKey.currentState!.validate()) return;

    // Diálogo de carga premium
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
              const SizedBox(height: 20),
              Text(
                'Procesando Transacción...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simular retraso de red de 2 segundos para dar realismo
    await Future.delayed(const Duration(seconds: 2));

    final estado = simularPago();

    await firebaseService.guardarPago(
      producto: widget.producto.nombre,
      total: widget.producto.totalConDesgloseSiAplica(),
      titular: titularCtrl.text,
      tarjeta: tarjetaCtrl.text,
      estado: estado,
    );

    if (!mounted) return;
    
    // Quitar diálogo de carga
    Navigator.pop(context);

    // Ir al resultado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoPage(estado: estado),
      ),
    );
  }

  // Detectar la red de tarjeta según el número
  String _detectCardBrand(String number) {
    if (number.isEmpty) return 'GENERIC';
    final firstDigit = number[0];
    if (firstDigit == '4') return 'VISA';
    if (firstDigit == '5') return 'MASTERCARD';
    if (firstDigit == '3') return 'AMEX';
    return 'GENERIC';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Pago'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tarjeta de Crédito 3D Animada
                      Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            titularCtrl,
                            tarjetaCtrl,
                            expiracionCtrl,
                            cvvCtrl,
                          ]),
                          builder: (context, _) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: _showBack ? pi : 0),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              builder: (context, angle, child) {
                                final isBack = angle >= pi / 2;
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001) // Perspectiva 3D
                                    ..rotateY(angle),
                                  alignment: Alignment.center,
                                  child: isBack
                                      ? Transform(
                                          transform: Matrix4.identity()..rotateY(pi),
                                          alignment: Alignment.center,
                                          child: _buildCardBack(cvvCtrl.text),
                                        )
                                      : _buildCardFront(
                                          tarjetaCtrl.text,
                                          titularCtrl.text,
                                          expiracionCtrl.text,
                                        ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Campos del Formulario
                      const Text(
                        'Datos de la Tarjeta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Input Titular
                      TextFormField(
                        controller: titularCtrl,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _inputDecoration(
                          label: 'Nombre del titular',
                          icon: Icons.person_outline_rounded,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingrese el nombre del titular'
                            : null,
                      ),
                      
                      const SizedBox(height: 16),

                      // Input Tarjeta
                      TextFormField(
                        controller: tarjetaCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardNumberInputFormatter(),
                        ],
                        decoration: _inputDecoration(
                          label: 'Número de tarjeta',
                          icon: Icons.credit_card_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese el número';
                          }
                          if (value.replaceAll(' ', '').length < 16) {
                            return 'Debe tener 16 dígitos';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),

                      // Fila Expiración y CVV
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: expiracionCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CardExpirationFormatter(),
                              ],
                              decoration: _inputDecoration(
                                label: 'Expiración (MM/AA)',
                                icon: Icons.calendar_today_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Ingrese fecha';
                                if (!value.contains('/') || value.length < 5) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: cvvCtrl,
                              focusNode: cvvFocusNode,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: _inputDecoration(
                                label: 'CVV',
                                icon: Icons.lock_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Ingrese CVV';
                                if (value.length < 3) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botón de Pagar fijado abajo
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1), // Indigo
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: procesarPago,
                  child: Text(
                    'Pagar S/ ${widget.producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estilo de Inputs moderno
  InputDecoration _inputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  // --- VISTA FRONTAL DE LA TARJETA VIRTUAL ---
  Widget _buildCardFront(String number, String holder, String expiry) {
    final displayNum = number.isEmpty ? '•••• •••• •••• ••••' : number;
    final displayHolder = holder.isEmpty ? 'NOMBRE APELLIDO' : holder.toUpperCase();
    final displayExpiry = expiry.isEmpty ? 'MM/AA' : expiry;
    final brand = _detectCardBrand(number);

    return Container(
      width: 320,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E293B), // Slate 800
            Color(0xFF334155), // Slate 700
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chip Metálico
              Container(
                width: 44,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.8), // Dorado
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                  ),
                ),
              ),
              // Icono Red de Tarjeta
              _buildBrandIcon(brand),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Número de Tarjeta
          Text(
            displayNum,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          
          // Pie de Tarjeta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Titular
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TITULAR DE TARJETA',
                      style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayHolder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Expiración
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRA',
                    style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayExpiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- VISTA TRASERA DE LA TARJETA VIRTUAL ---
  Widget _buildCardBack(String cvv) {
    final displayCvv = cvv.isEmpty ? '•••' : cvv;

    return Container(
      width: 320,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banda Magnética Negra
          Container(
            height: 40,
            color: Colors.black,
            width: double.infinity,
          ),
          
          const SizedBox(height: 24),
          
          // Contenedor de firma y CVV
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: const Text(
                      'Firmada',
                      style: TextStyle(
                        color: Colors.black38,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // CVV
                Container(
                  width: 50,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber.shade400, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    displayCvv,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandIcon(String brand) {
    if (brand == 'VISA') {
      return const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      );
    } else if (brand == 'MASTERCARD') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: const Color(0xFFF79E1B).withOpacity(0.85), shape: BoxShape.circle),
            ),
          ),
        ],
      );
    } else if (brand == 'AMEX') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'AMEX',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      );
    }
    return const Icon(Icons.payment_rounded, color: Colors.white70);
  }
}

// Extensión para obtener el precio total, evitando errores de tipo
extension on Producto {
  double totalConDesgloseSiAplica() {
    return precio;
  }
}