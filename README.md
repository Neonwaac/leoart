# LeoArt

LeoArt es una aplicación móvil desarrollada en Flutter que permite a un artista exhibir y gestionar sus obras de arte en una galería digital moderna. La aplicación está diseñada para ofrecer una experiencia visual elegante, permitiendo a los usuarios explorar colecciones, conocer los detalles de cada obra y, en futuras versiones, realizar compras.

## Tecnologías

- Flutter
- Firebase Authentication
- Cloud Firestore
- Cloudinary
- Material 3

## Características

- Catálogo de obras estilo galería.
- Información detallada de cada obra.
- Gestión de colecciones.
- Perfil del artista.
- Modo claro y modo oscuro.
- Panel de administración para gestionar obras.
- Almacenamiento de imágenes mediante Cloudinary.
- Datos almacenados en Cloud Firestore.

## Estructura del proyecto

```text
lib/
├── assets/
├── components/
├── features/
├── models/
├── services/
├── themes/
├── utils/
├── views/
└── main.dart
```

## Configuración

1. Clonar el repositorio.

```bash
git clone <repository-url>
```

2. Instalar las dependencias.

```bash
flutter pub get
```

3. Configurar Firebase para Android e iOS.

4. Configurar las credenciales de Cloudinary.

5. Ejecutar la aplicación.

```bash
flutter run
```

## Arquitectura

La aplicación sigue una arquitectura modular orientada a facilitar el mantenimiento y la escalabilidad del proyecto. Firestore almacena toda la información estructurada, mientras que Cloudinary gestiona el almacenamiento y distribución de las imágenes.

## Estado del proyecto

Actualmente el proyecto se encuentra en desarrollo.