import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Fondo oscuro + header arriba + hoja crema con body y footer anclado abajo.
class AuthScaffold extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;

  const AuthScaffold({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            header,
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Expanded(child: ListView(children: [body])),
                    const SizedBox(height: 16),
                    footer,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
