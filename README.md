# Flutter Auth App

Una aplicación móvil sencilla en Flutter que implementa autenticación de usuario, persistencia de sesión segura, acceso a ubicación bajo demanda y gestión eficiente del estado y recursos.

---

## Características

- Inicio de sesión con email y contraseña
- Persistencia segura del token de sesión usando `flutter_secure_storage`
- Gestión de estado global con `Provider`
- Redirección automática según sesión activa
- Solicitud de ubicación solo cuando es necesario (usando `geolocator`)
- Detención de ubicación al cerrar sesión para ahorro de recursos

---

## Justificación del gestor de estado global

Elegí `Provider` porque es un gestor de estado simple y oficial en Flutter. Al ser principiante, necesitaba algo fácil de aprender, pero que también permita escalar la app si crece. `Provider` me permite:

- Compartir datos como el usuario autenticado o el token en toda la app.
- Escuchar cambios de estado de forma eficiente (solo las partes necesarias se actualizan).
- Mantener una estructura clara y separada (modelo, lógica, vistas).

---

## Estrategias aplicadas para la seguridad

Para proteger los datos de sesión del usuario, se implementó `flutter_secure_storage`, que permite guardar el token de autenticación de forma cifrada. Esto es más seguro que usar `SharedPreferences`, ya que impide el acceso fácil desde otras apps o usuarios maliciosos.

También se implementó una validación antes de acceder a cualquier pantalla privada. Si el token no existe o no es válido, se redirige automáticamente al login. Esta lógica funciona como un *middleware* en desarrollo web, actuando como un filtro que bloquea el acceso no autorizado.

---

## Medidas tomadas para optimizar el manejo de recursos

La aplicación solicita acceso a la **ubicación del dispositivo**, pero lo hace solo cuando es necesario (por ejemplo, al entrar a una pantalla que muestra datos basados en la ubicación).

Para optimizar el uso de batería y memoria:

- Se usa la librería `geolocator`, que permite controlar cuándo iniciar y detener el seguimiento.
- Al **cerrar sesión**, se detiene explícitamente el acceso a la ubicación para evitar procesos en segundo plano innecesarios.
- El permiso solo se solicita una vez, y la app respeta la decisión del usuario.

---

## Requisitos

- Flutter SDK
- Android Studio o VS Code
- Emulador Android o dispositivo físico

---

## Instalación

```bash
git clone https://github.com/Edwing518/flutter_application_1.git
cd flutter_auth_app
flutter pub get
flutter run
```

---

## Autor

Edwin (Proyecto educativo)
