import 'package:flutter/material.dart';

import '../../../widgets/marea_brand.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openLogin();
  }

  Future<void> _openLogin() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: MareaBrand()));
  }
}
