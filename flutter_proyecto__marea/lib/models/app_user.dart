// Datos del usuario guardados en Firestore, en users/{uid}.
class AppUser {
  const AppUser({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.pais,
    this.genero,
    this.ocupacion,
    this.direccion,
    this.fcmToken,
  });

  final String uid;
  final String nombre;
  final String apellido;
  final String email;
  final String? pais;
  final String? genero;
  final String? ocupacion;
  final String? direccion;
  final String? fcmToken;

  String get fullName => '$nombre $apellido'.trim();

  String get initials => fullName
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      nombre: data['nombre'] as String? ?? '',
      apellido: data['apellido'] as String? ?? '',
      email: data['email'] as String? ?? '',
      pais: data['pais'] as String?,
      genero: data['genero'] as String?,
      ocupacion: data['ocupacion'] as String?,
      direccion: data['direccion'] as String?,
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'apellido': apellido,
    'email': email,
    'pais': pais,
    'genero': genero,
    'ocupacion': ocupacion,
    'direccion': direccion,
  };
}
