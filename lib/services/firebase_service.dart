import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore db =
      FirebaseFirestore.instance;

  Future guardarPago({
    required String producto,
    required double total,
    required String titular,
    required String tarjeta,
    required String estado,
  }) async {
    await db.collection(
      'pagos_simulados',
    ).add({
      'producto': producto,
      'total': total,
      'titular': titular,
      'ultimos4':
          tarjeta.substring(
              tarjeta.length - 4),
      'estado': estado,
      'fecha':
          FieldValue.serverTimestamp(),
    });
  }
}