import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/group_provider.dart';

// Abre una pantalla del grupo compartiéndole el mismo GroupProvider.
void pushInGroup(BuildContext context, Widget page) {
  final provider = context.read<GroupProvider>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          ChangeNotifierProvider.value(value: provider, child: page),
    ),
  );
}

void showGroupMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
