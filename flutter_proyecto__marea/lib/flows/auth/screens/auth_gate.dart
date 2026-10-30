import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../widgets/marea_brand.dart';
import '../../diario/screens/diary_shell_screen.dart';
import 'login_screen.dart';

// Si no hay sesión muestra el login; si la hay, el diario.
// Cambia de pantalla solo cuando alguien inicia o cierra sesión.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: MareaBrand()));
        }
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        return const DiaryShellScreen();
      },
    );
  }
}
