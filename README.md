# LeoArt

LeoArt es una plataforma compuesta por dos aplicaciones Flutter independientes que comparten un mismo dominio de negocio.

## Aplicaciones

- **leoart_app**: Aplicación pública para clientes (Android, iOS)
- **leoart_admin**: Panel de administración (Android, iOS, Web, Windows)

## Tecnologías

- Flutter 3.44+
- Riverpod (estado global)
- GoRouter (navegación)
- Freezed + json_serializable (modelos inmutables)
- Firebase (autenticación, Firestore)
- Cloudinary (almacenamiento de imágenes)
- Material 3
- Melos (gestión del monorepo)

## Estructura del proyecto

```
leoart/
├── apps/
│   ├── leoart_app/
│   └── leoart_admin/
├── packages/
│   └── shared/
├── docs/
├── prompts/
├── melos.yaml (deprecated - uses pub workspaces)
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
└── README.md
```

## Arquitectura Flutter

Cada aplicación sigue una arquitectura Feature First con Clean Architecture ligera:

```
lib/
├── core/
├── features/
├── shared/
├── services/
├── navigation/
├── theme/
└── main.dart
```

## Configuración

1. Clonar el repositorio.
2. Ejecutar `dart pub get` en la raíz.
3. Configurar las credenciales de Cloudinary (ver `.env.example`).
4. Ejecutar la aplicación con `flutter run`.

## Configuración de Firebase

Los archivos de configuración de Firebase se gestionan mediante FlutterFire CLI.
Los archivos específicos de cada plataforma ya están ubicados en sus directorios correspondientes.
