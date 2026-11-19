import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';
import 'chat_screen.dart';

// Integrantes del grupo (desde Firestore) y el chat general.
class InteractionZoneScreen extends StatelessWidget {
  const InteractionZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final members = provider.otherMembers;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            children: [
              const PageHeader(
                title: 'Zona de interacción',
                subtitle: 'Conecta con otras personas del grupo',
              ),
              const SizedBox(height: 18),
              GlobalChatCard(
                onPressed: () => pushInGroup(
                  context,
                  ChatScreen(
                    title: provider.group.name,
                    color: provider.group.color,
                    hint: 'Escribe algo',
                    isGroup: true,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Integrantes del grupo',
                style: TextStyle(color: mutedColor(context), fontSize: 14),
              ),
              const SizedBox(height: 12),
              if (provider.loading && members.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (members.isEmpty)
                Text(
                  provider.error ??
                      'Aún no hay otros integrantes. Cuando alguien más entre '
                          'al grupo aparecerá aquí.',
                  style: TextStyle(color: mutedColor(context), height: 1.4),
                )
              else
                for (final member in members)
                  SuggestedProfileCard(
                    name: member.name,
                    status: member.status,
                    initials: member.initials,
                    color: member.color,
                    online: member.online,
                    onChat: () => pushInGroup(
                      context,
                      ChatScreen(
                        title: member.name,
                        subtitle: 'Integrante del grupo',
                        initials: member.initials,
                        color: member.color,
                        hint: 'Escribe un mensaje',
                        withUid: member.uid,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
