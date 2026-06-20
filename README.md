# 💳 Pasarela de Pago Simulada

Aplicación móvil desarrollada en **Flutter + Firebase Firestore** que simula el proceso de compra de productos mediante una pasarela de pago. La aplicación valida los datos ingresados por el usuario, genera un resultado aleatorio de aprobación o rechazo y registra cada transacción en Firebase.

---

## 📱 Descripción

Este proyecto fue desarrollado como parte del taller de **Simulación de Pasarela de Pago en Flutter**.

La aplicación permite:

* Visualizar productos disponibles.
* Consultar el resumen de compra.
* Ingresar datos de pago simulados.
* Validar la información ingresada.
* Simular pagos aprobados o rechazados.
* Registrar transacciones en Firebase Firestore.
* Consultar historial de pagos realizados.

> ⚠️ Importante: No se almacenan números completos de tarjeta ni códigos CVV. Únicamente se guardan los últimos 4 dígitos por motivos de seguridad.

---

# 🚀 Tecnologías Utilizadas

* Flutter
* Dart
* Firebase Core
* Cloud Firestore
* Material Design 3

---

# 📂 Estructura del Proyecto

```text
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
```

---

# ⚙️ Funcionalidades Implementadas

## 🛒 Catálogo de Productos

La aplicación presenta una lista de productos disponibles para compra.

### Características

* Visualización de nombre y precio.
* Navegación al resumen de compra.
* Diseño moderno con Material Design.

### Captura

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/fecb5f85-6847-4479-9a09-1312434e421b" />

---

## 📋 Resumen de Compra

Permite visualizar el producto seleccionado y el valor total a pagar antes de continuar al proceso de pago.

### Captura

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/3fdcf129-e4eb-431c-ab88-b9e7665abacf" />

---

## 💳 Formulario de Pago

El usuario debe completar los siguientes datos:

* Nombre del titular
* Número de tarjeta
* Fecha de expiración
* CVV

### Validaciones

✔ Titular obligatorio

✔ Tarjeta obligatoria

✔ Tarjeta con mínimo 16 dígitos

✔ Fecha obligatoria

✔ CVV obligatorio

✔ CVV de 3 dígitos

### Captura

📸 Agregar captura aquí

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/dd586891-2192-4976-9769-fb06503ce7b1" />

---

## 🔄 Simulación de Pago

La aplicación genera aleatoriamente un resultado:

* APROBADO
* RECHAZADO

Utilizando:

```dart
Random().nextBool()
```

### Captura

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/31ebc2b4-415f-4f5a-904d-a4dd1eee2afb" />

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/b6127e82-0ac2-465d-9255-142421e258c4" />

---

## ✅ Resultado del Pago

Se muestra al usuario el estado final de la transacción.

### Estados

* Pago Aprobado
* Pago Rechazado

### HISTORIAL DE PAGOS

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/a2f40749-cc59-4fa0-a250-7f400bc90550" />


### DASHBOARD

<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/62187da2-b56b-4a2b-aead-5efa744ad0fa" />


---

## 🔥 Integración con Firebase Firestore

Cada transacción simulada se almacena automáticamente en Firestore.

### Datos Guardados

| Campo    | Descripción                     |
| -------- | ------------------------------- |
| producto | Nombre del producto             |
| total    | Valor total                     |
| titular  | Nombre del titular              |
| ultimos4 | Últimos 4 dígitos de la tarjeta |
| estado   | APROBADO o RECHAZADO            |
| fecha    | Fecha y hora del registro       |

### Ejemplo de Registro

```json
{
  "producto": "Teclado Mecánico",
  "total": 45,
  "titular": "Odaliz Balseca",
  "ultimos4": "5678",
  "estado": "APROBADO",
  "fecha": "2026-06-19"
}
```

### Captura Firestore

📸 Agregar captura aquí

```text
assets/screenshots/firebase.png
```

---

# 📜 Historial de Pagos

Muestra todas las transacciones registradas en Firebase.

### Información mostrada

* Producto
* Monto
* Estado
* Fecha
* Últimos 4 dígitos

### Captura

📸 Agregar captura aquí

```text
assets/screenshots/historial.png
```

---

# 📊 Dashboard

Panel de estadísticas generales.

### Indicadores

* Total de pagos
* Pagos aprobados
* Pagos rechazados
* Ventas simuladas

### Captura

📸 Agregar captura aquí

```text
assets/screenshots/dashboard.png
```

---

# 🔒 Seguridad Implementada

Para cumplir con buenas prácticas de desarrollo:

✅ No se almacena la tarjeta completa.

✅ No se almacena el CVV.

✅ Se guardan únicamente los últimos 4 dígitos.

✅ Los registros se almacenan en Firebase Firestore.

---

# ▶️ Ejecución del Proyecto

## Instalar dependencias

```bash
flutter pub get
```

## Ejecutar proyecto

```bash
flutter run
```

## Generar APK

```bash
flutter build apk --release
```

---

# 📦 Dependencias Utilizadas

```yaml
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^4.0.0
  cloud_firestore: ^6.0.0
```

---

# 👩‍💻 Autor

**Odaliz Balseca**

Desarrollo de Aplicaciones Móviles

Flutter + Firebase

---

# 📄 Licencia

Proyecto desarrollado con fines académicos para el taller de Simulación de Pasarela de Pago en Flutter.
