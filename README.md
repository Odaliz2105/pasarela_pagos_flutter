mediante una pasarela de pago. La aplicación valida los datos ingresados por el usuario, genera un resultado aleatorio de aprobación o rechazo y registra cada transacción en Firebase.

📱 Descripción

Este proyecto fue desarrollado como parte del taller de Simulación de Pasarela de Pago en Flutter.

La aplicación permite:

Visualizar productos disponibles.
Consultar el resumen de compra.
Ingresar datos de pago simulados.
Validar la información ingresada.
Simular pagos aprobados o rechazados.
Registrar transacciones en Firebase Firestore.
Consultar historial de pagos realizados.

⚠️ Importante: No se almacenan números completos de tarjeta ni códigos CVV. Únicamente se guardan los últimos 4 dígitos por motivos de seguridad.

🚀 Tecnologías Utilizadas
Flutter
Dart
Firebase Core
Cloud Firestore
Material Design 3
📂 Estructura del Proyecto
lib/
│
├── data/
│   └── productos_data.dart
│
├── models/
│   └── producto.dart
│
├── pages/
│   ├── productos_page.dart
│   ├── resumen_page.dart
│   ├── pago_page.dart
│   ├── resultado_page.dart
│   ├── historial_page.dart
│   └── dashboard_page.dart
│
├── services/
│   ├── firebase_service.dart
│   └── simulador_pago.dart
│
├── firebase_options.dart
│
└── main.dart
⚙️ Funcionalidades Implementadas
🛒 Catálogo de Productos

La aplicación presenta una lista de productos disponibles para compra.

Características
Visualización de nombre y precio.
Navegación al resumen de compra.
Diseño moderno con Material Design.
Captura

📸 Agregar captura aquí

assets/screenshots/productos.png
📋 Resumen de Compra

Permite visualizar el producto seleccionado y el valor total a pagar antes de continuar al proceso de pago.

Captura

📸 Agregar captura aquí

assets/screenshots/resumen.png
💳 Formulario de Pago

El usuario debe completar los siguientes datos:

Nombre del titular
Número de tarjeta
Fecha de expiración
CVV
Validaciones

✔ Titular obligatorio

✔ Tarjeta obligatoria

✔ Tarjeta con mínimo 16 dígitos

✔ Fecha obligatoria

✔ CVV obligatorio

✔ CVV de 3 dígitos

Captura

📸 Agregar captura aquí

assets/screenshots/pago.png
🔄 Simulación de Pago

La aplicación genera aleatoriamente un resultado:

APROBADO
RECHAZADO

Utilizando:

Random().nextBool()
Captura

📸 Agregar captura aquí

assets/screenshots/procesando.png
✅ Resultado del Pago

Se muestra al usuario el estado final de la transacción.

Estados
Pago Aprobado
Pago Rechazado
Captura Aprobado

📸 Agregar captura aquí

assets/screenshots/aprobado.png
Captura Rechazado

📸 Agregar captura aquí

assets/screenshots/rechazado.png
🔥 Integración con Firebase Firestore

Cada transacción simulada se almacena automáticamente en Firestore.

Datos Guardados
Campo	Descripción
producto	Nombre del producto
total	Valor total
titular	Nombre del titular
ultimos4	Últimos 4 dígitos de la tarjeta
estado	APROBADO o RECHAZADO
fecha	Fecha y hora del registro
Ejemplo de Registro
{
  "producto": "Teclado Mecánico",
  "total": 45,
  "titular": "Odaliz Balseca",
  "ultimos4": "5678",
  "estado": "APROBADO",
  "fecha": "2026-06-19"
}
Captura Firestore

📸 Agregar captura aquí

assets/screenshots/firebase.png
📜 Historial de Pagos

Muestra todas las transacciones registradas en Firebase.

Información mostrada
Producto
Monto
Estado
Fecha
Últimos 4 dígitos
Captura

📸 Agregar captura aquí

assets/screenshots/historial.png
📊 Dashboard

Panel de estadísticas generales.

Indicadores
Total de pagos
Pagos aprobados
Pagos rechazados
Ventas simuladas
Captura

📸 Agregar captura aquí

assets/screenshots/dashboard.png
🔒 Seguridad Implementada

Para cumplir con buenas prácticas de desarrollo:

✅ No se almacena la tarjeta completa.

✅ No se almacena el CVV.

✅ Se guardan únicamente los últimos 4 dígitos.

✅ Los registros se almacenan en Firebase Firestore.

▶️ Ejecución del Proyecto
Instalar dependencias
flutter pub get
Ejecutar proyecto
flutter run
Generar APK
flutter build apk --release
📦 Dependencias Utilizadas
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^4.0.0
  cloud_firestore: ^6.0.0
👩‍💻 Autor

Odaliz Balseca

Desarrollo de Aplicaciones Móviles

Flutter + Firebase

📄 Licencia

Proyecto desarrollado con fines académicos para el taller de Simulación de Pasarela de Pago en Flutter.
