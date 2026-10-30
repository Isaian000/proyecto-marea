import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/profile_widgets.dart';
import 'about_screen.dart';
import 'account_screen.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _sendingEmail = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _sendVerification() async {
    setState(() => _sendingEmail = true);
    try {
      await AuthService.sendEmailVerification();
      _showMessage('Te enviamos el correo de verificación.');
    } catch (e) {
      _showMessage(AuthService.errorMessage(e));
    } finally {
      if (mounted) setState(() => _sendingEmail = false);
    }
  }

  Future<void> _checkVerification() async {
    final verified = await AuthService.reloadEmailVerified();
    if (!mounted) return;
    setState(() {});
    _showMessage(
      verified
          ? '¡Listo! Tu correo ya está verificado.'
          : 'Todavía no aparece verificado. Revisa tu correo.',
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar tu cuenta?'),
        content: const Text(
          'Se borrará tu cuenta de Marea y no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.orange),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await AuthService.deleteAccount();
      navigator.popUntil((route) => route.isFirst);
      messenger.showSnackBar(
        const SnackBar(content: Text('Tu cuenta fue eliminada')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(AuthService.errorMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final email = user?.email ?? '';
    final name = AuthService.displayName;
    final needsVerification =
        AuthService.usesPassword && !(user?.emailVerified ?? true);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const ProfileBackButton(),
                    const SizedBox(height: 16),
                    const ProfileScreenTitle('Mi perfil'),
                    const SizedBox(height: 28),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.gold,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL != null
                          ? null
                          : Text(
                              AuthService.initials,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontFamily: 'Georgia',
                                fontFamilyFallback: ['serif'],
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor(context),
                        fontFamily: 'Georgia',
                        fontFamilyFallback: const ['serif'],
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mutedColor(context),
                        fontSize: 15,
                      ),
                    ),
                    if (needsVerification) ...[
                      const SizedBox(height: 20),
                      _VerifyEmailCard(
                        sending: _sendingEmail,
                        onSend: _sendVerification,
                        onCheck: _checkVerification,
                      ),
                    ],
                    const SizedBox(height: 32),
                    ProfileOption(
                      icon: Icons.person_outline,
                      label: 'Información personal',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalInformationScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileOption(
                      icon: Icons.lock_outline,
                      label: 'Correo y contraseña',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileOption(
                      icon: Icons.info_outline,
                      label: 'Nosotros',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: textColor(context),
                  side: const BorderSide(color: Color(0xFF718087)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () => logOut(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Cerrar sesión',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _deleteAccount,
                child: const Text(
                  'Eliminar cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// aviso para verificar el correo, solo si la cuenta es de correo y contraseña
class _VerifyEmailCard extends StatelessWidget {
  final bool sending;
  final VoidCallback onSend;
  final VoidCallback onCheck;

  const _VerifyEmailCard({
    required this.sending,
    required this.onSend,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verifica tu correo',
            style: TextStyle(
              color: textColor(context),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Abre el enlace que te mandamos para confirmar tu dirección.',
            style: TextStyle(color: mutedColor(context)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: sending ? null : onSend,
                child: Text(sending ? 'Enviando...' : 'Reenviar correo'),
              ),
              TextButton(
                onPressed: onCheck,
                child: const Text('Ya lo verifiqué'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
