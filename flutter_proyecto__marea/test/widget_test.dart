import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_proyecto_marea/core/app_theme.dart';
import 'package:flutter_proyecto_marea/flows/auth/screens/login_screen.dart';
import 'package:flutter_proyecto_marea/flows/diario/screens/diary_shell_screen.dart';
import 'package:flutter_proyecto_marea/flows/community/screens/community_forums_screen.dart';
import 'package:flutter_proyecto_marea/models/forum.dart';
import 'package:flutter_proyecto_marea/models/group_summary.dart';
import 'package:flutter_proyecto_marea/providers/community_provider.dart';
import 'package:flutter_proyecto_marea/providers/notifications_provider.dart';
import 'package:flutter_proyecto_marea/services/community_service.dart';
import 'package:flutter_proyecto_marea/providers/records_provider.dart';
import 'package:flutter_proyecto_marea/providers/theme_provider.dart';
import 'package:flutter_proyecto_marea/providers/user_provider.dart';

// Firebase no se inicializa en los tests, así que se prueban las pantallas
// directamente: el login (sin enviar nada) y el diario sin usuario.
// Sin Firebase, UserProvider no carga ningún usuario.
Widget _app(Widget home, {CommunityProvider? community}) => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => NotificationsProvider()),
    ChangeNotifierProvider(create: (_) => RecordsProvider()),
    ChangeNotifierProvider(create: (_) => community ?? CommunityProvider()),
  ],
  child: MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    home: home,
  ),
);

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

// Comunidad en memoria, con los mismos foros y grupos iniciales.
class _FakeCommunity implements CommunityRepository {
  final forums = [...seedForums];
  final groups = [...seedGroups];

  @override
  Future<List<Forum>> fetchForums() async => forums;

  @override
  Future<List<GroupSummary>> fetchMyGroups(String uid) async =>
      groups.where((g) => g.memberIds.contains(uid)).toList();

  @override
  Future<void> joinForum(String uid, Forum forum) async {
    final i = groups.indexWhere((g) => g.id == forum.groupId);
    final g = groups[i];
    groups[i] = GroupSummary(
      id: g.id,
      name: g.name,
      topic: g.topic,
      category: g.category,
      isPublic: g.isPublic,
      memberIds: [...g.memberIds, uid],
    );
  }

  @override
  Future<void> requestAccess(String uid, Forum forum) async {}
}

void main() {
  testWidgets('el login muestra correo, contraseña y Google', (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(_app(const LoginScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola de nuevo'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);

    // Sin datos no intenta entrar, solo avisa.
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    expect(find.text('Escribe tu correo y tu contraseña.'), findsOneWidget);

    await tester.tap(find.text('Regístrate'));
    await tester.pumpAndSettle();
    expect(find.text('Crea tu cuenta'), findsOneWidget);
  });

  testWidgets('muestra el registro diario y navega al historial', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(_app(const DiaryShellScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola'), findsOneWidget);
    expect(find.text('Guardar registro'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.schedule_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Historial'), findsAtLeastNWidgets(1));
    // Sin sesión no hay registros: muestra el mensaje para empezar.
    expect(find.textContaining('Aún no tienes registros'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.notifications_none));
    await tester.pumpAndSettle();

    expect(find.text('Notificaciones'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.text('Mi perfil'), findsOneWidget);
    expect(find.text('Eliminar cuenta'), findsOneWidget);
    await tester.tap(find.text('Información personal'));
    // Sin usuario se queda cargando, así que no se usa pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Guardar cambios'), findsOneWidget);
  });

  testWidgets('comunidad: unirse a un foro lo agrega a Mis grupos', (
    tester,
  ) async {
    _phoneSize(tester);
    final community = CommunityProvider(
      repository: _FakeCommunity(),
      currentUid: () => 'u1',
    );
    await tester.pumpWidget(
      _app(const Scaffold(body: CommunityForumsScreen()), community: community),
    );
    await tester.pumpAndSettle();

    expect(find.text('Foro de ansiedad 1'), findsOneWidget);
    expect(find.text('Mandar solicitud'), findsOneWidget);

    await tester.tap(find.text('Mis grupos'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Aún no estás en ningún grupo'), findsOneWidget);

    await tester.tap(find.text('Foros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unirse').first);
    await tester.pumpAndSettle();
    expect(find.text('Hablemos de ansiedad'), findsOneWidget);

    await tester.tap(find.text('Registrarme'));
    await tester.pumpAndSettle();
    expect(find.text('Registro exitoso'), findsOneWidget);

    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    expect(find.text('Unido'), findsOneWidget);

    await tester.tap(find.text('Mis grupos'));
    await tester.pumpAndSettle();
    expect(find.text('Grupo Ansiedad'), findsOneWidget);
    expect(find.text('1 integrante'), findsOneWidget);
  });
}
