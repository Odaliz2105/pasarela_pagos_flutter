import 'dart:math';

String simularPago() {
  bool aprobado = Random().nextBool();

  return aprobado
      ? 'APROBADO'
      : 'RECHAZADO';
}