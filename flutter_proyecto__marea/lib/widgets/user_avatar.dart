import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

// Foto del usuario. Si no tiene foto guardada en el teléfono usa la de su
// cuenta de Google; si tampoco hay, muestra sus iniciales o un ícono.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.radius = 22, this.fontSize});

  final double radius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final localPath = provider.photoPath;
    final googlePhoto = AuthService.currentUser?.photoURL;
    final initials = provider.initials.isNotEmpty
        ? provider.initials
        : AuthService.initials;

    ImageProvider? image;
    if (localPath != null && !kIsWeb) {
      image = FileImage(File(localPath));
    } else if (googlePhoto != null) {
      image = NetworkImage(googlePhoto);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.gold,
      backgroundImage: image,
      child: image != null
          ? null
          : initials.isEmpty
          ? const Icon(Icons.person, color: AppColors.ink)
          : Text(
              initials,
              style: TextStyle(
                color: AppColors.ink,
                fontFamily: 'Georgia',
                fontFamilyFallback: const ['serif'],
                fontSize: fontSize ?? radius * 0.7,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
