import 'dart:async';

import 'package:flutter/material.dart';

import '../../../widgets/marea_brand.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogin = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showLogin = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return const LoginScreen();
    }
    return const Scaffold(body: Center(child: MareaBrand()));
  }
}
