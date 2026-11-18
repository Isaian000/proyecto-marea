# proyecto-marea

Marea: diario emocional con comunidad y grupos de apoyo, hecho en Flutter con Firebase.

El código de la app está en `flutter_proyecto__marea/`.

## Cómo correrlo

```
cd flutter_proyecto__marea
flutter pub get
flutter run
```

La app usa el proyecto de Firebase `proyecto-1-5a63c`. Para que te funcione el inicio de sesión con Google en Android, registra la huella SHA-1 de tu computadora en ese proyecto (`cd android` y luego `./gradlew signingReport`).

## Estructura de carpetas (`lib/`)

| Carpeta | Qué va ahí |
|---|---|
| `core/` | Colores, tema y tipografías |
| `models/` | Clases de datos (`AppUser`, `EmotionalRecord`, ...) |
| `services/` | Llamadas a Firebase y a APIs (funciones `Future`) |
| `providers/` | Estado de la app con Provider (`ThemeProvider`, `UserProvider`, ...) |
| `flows/<módulo>/screens/` | Pantallas de cada módulo |
| `widgets/` | Componentes reutilizables |

Las pantallas no llaman a Firebase directamente: usan un provider, y el provider usa un service.

## Estructura de Firestore

Usen exactamente estos nombres de colecciones y campos.

```
users/{uid}
  nombre: string
  apellido: string
  email: string
  pais: string | null
  genero: string | null
  ocupacion: string | null   // opcional
  direccion: string | null   // opcional
  fcmToken: string          // token del dispositivo
  createdAt, updatedAt, tokenUpdatedAt: timestamp

users/{uid}/records/{yyyy-MM-dd}      // diario (CRUD), un registro por día; el id es la fecha
  date: timestamp
  mood: number (0 a 1)
  moodLabel: string
  note: string
  energy: string
  sleep: string
  thoughts: string
  createdAt, updatedAt: timestamp

users/{uid}/notifications/{id}
  title: string
  body: string
  type: string   // diario | foros | comentarios | logro | sistema (define el ícono)
  read: bool
  createdAt: timestamp

forums/{forumId}
  name, description, ...
forums/{forumId}/topics/{topicId}
  title, text, authorId, authorName, votes, createdAt
forums/{forumId}/topics/{topicId}/comments/{commentId}
  text, authorId, authorName, createdAt

groups/{groupId}
  name, description, ...
groups/{groupId}/messages/{messageId}
  text, authorId, authorName, createdAt
groups/{groupId}/resources/{resourceId}
  title, text, type, createdAt
```

La foto de perfil se guarda solo en el teléfono (no en Firestore): se copia a la carpeta de la app y su ruta se guarda con `shared_preferences` en la clave `profilePhoto_{uid}`.

Para crear una notificación desde cualquier parte de la app:

```dart
NotificationService.create(uid, title: 'Foros', body: 'Alguien comentó tu tema.', type: 'foros');
```

## Reglas de Firestore sugeridas

Pegarlas en la consola de Firebase, en Firestore Database → Reglas.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cada usuario solo lee y escribe lo suyo.
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    // Comunidad y grupos: cualquier usuario con sesión.
    match /forums/{document=**} {
      allow read, write: if request.auth != null;
    }
    match /groups/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Cómo trabajamos

- Una rama por persona (`feature/...`) y pull request para unir a `main`.
- Si necesitas un paquete nuevo, avísale a Carlos antes de tocar `pubspec.yaml`.
- `git pull` seguido y commits pequeños.
