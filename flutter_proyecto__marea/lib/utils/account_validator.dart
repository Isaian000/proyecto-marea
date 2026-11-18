// Revisa los datos de la pantalla "Correo y contraseña" antes de mandarlos a
// Firebase. Devuelve el mensaje de error, o null si todo está bien.
String? validateAccountChange({
  required String currentEmail,
  required String newEmail,
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) {
  final email = newEmail.trim();
  final emailChanged =
      email.toLowerCase() != currentEmail.trim().toLowerCase();
  final passwordChanged = newPassword.isNotEmpty || confirmPassword.isNotEmpty;

  if (!emailChanged && !passwordChanged) {
    return 'No hay cambios para guardar.';
  }
  if (emailChanged && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Escribe un correo válido.';
  }
  if (passwordChanged) {
    if (newPassword.length < 6) {
      return 'La contraseña nueva debe tener al menos 6 caracteres.';
    }
    if (newPassword != confirmPassword) {
      return 'Las contraseñas no coinciden.';
    }
  }
  if (currentPassword.isEmpty) {
    return 'Escribe tu contraseña actual para confirmar los cambios.';
  }
  if (passwordChanged && newPassword == currentPassword) {
    return 'La contraseña nueva debe ser diferente a la actual.';
  }
  return null;
}

bool emailWillChange(String currentEmail, String newEmail) =>
    newEmail.trim().toLowerCase() != currentEmail.trim().toLowerCase();
