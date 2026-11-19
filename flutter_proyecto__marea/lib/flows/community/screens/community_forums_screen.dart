import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../models/forum.dart';
import '../../../models/group_summary.dart';
import '../../../providers/community_provider.dart';
import '../../../widgets/community_widgets.dart';
import '../../../widgets/diary_widgets.dart';
import '../../group/screens/group_screen.dart';
import 'forum_intro_screen.dart';

// comunidad con foros y mis grupos, dentro de diaryshell
class CommunityForumsScreen extends StatefulWidget {
  const CommunityForumsScreen({super.key});

  @override
  State<CommunityForumsScreen> createState() => _CommunityForumsScreenState();
}

class _CommunityForumsScreenState extends State<CommunityForumsScreen> {
  int _tab = 0; // 0 foros, 1 mis grupos
  int _category = 0; // indice en Forum.categories

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CommunityProvider>().load();
    });
  }

  void _openForumIntro(Forum forum) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ForumIntroScreen(forum: forum)),
    );
  }

  Future<void> _sendRequest(Forum forum) async {
    final messenger = ScaffoldMessenger.of(context);
    String message;
    try {
      await context.read<CommunityProvider>().requestAccess(forum);
      message = 'Solicitud enviada';
    } catch (e) {
      message = 'No se pudo enviar la solicitud.';
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openGroup(GroupSummary group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupScreen(group: group),
      ),
    );
  }

  Widget _forumCard(Forum forum, String? uid) {
    final member = forum.isMember(uid);
    final requested = forum.hasRequested(uid);
    String? label;
    bool? filled;
    VoidCallback onPressed;

    if (member) {
      label = 'Unido';
      filled = false;
      onPressed = () => _showMessage('Ya eres parte de este foro.');
    } else if (forum.isPublic) {
      onPressed = () => _openForumIntro(forum);
    } else if (requested) {
      label = 'Solicitud enviada';
      filled = false;
      onPressed = () => _showMessage('Tu solicitud está pendiente.');
    } else {
      onPressed = () => _sendRequest(forum);
    }

    return ForumCard(
      title: forum.name,
      subtitle: forum.subtitle,
      color: forum.color,
      isPublic: forum.isPublic,
      actionLabel: label,
      actionFilled: filled,
      onPressed: onPressed,
    );
  }

  Widget _message(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: mutedColor(context), height: 1.5),
      ),
    );
  }

  List<Widget> _forumsTab(CommunityProvider provider) {
    final forums = provider.forumsIn(Forum.categories[_category]);
    return [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (i, label) in Forum.categoryLabels.indexed)
            CategoryChip(
              label: label,
              selected: _category == i,
              onTap: () => setState(() => _category = i),
            ),
        ],
      ),
      const SizedBox(height: 16),
      if (provider.loading && provider.forums.isEmpty)
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (forums.isEmpty)
        _message(
          context,
          provider.error ??
              (provider.uid == null
                  ? 'Inicia sesión para ver los foros.'
                  : 'No hay foros en esta categoría.'),
        )
      else
        for (final forum in forums) _forumCard(forum, provider.uid),
    ];
  }

  List<Widget> _groupsTab(CommunityProvider provider) {
    final groups = provider.myGroups;
    if (provider.loading && groups.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (groups.isEmpty) {
      return [
        _message(
          context,
          provider.error ??
              'Aún no estás en ningún grupo.\nÚnete a un foro para empezar.',
        ),
      ];
    }
    return [
      for (final group in groups)
        GroupCard(
          name: group.name,
          members: group.membersLabel,
          color: group.color,
          isPublic: group.isPublic,
          onPressed: () => _openGroup(group),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();

    return RefreshIndicator(
      onRefresh: provider.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        children: [
          TopHeader(
            title: 'Comunidad',
            subtitle: _tab == 0 ? 'Foros de apoyo' : 'Tus grupos',
            showProfile: true,
          ),
          const SizedBox(height: 20),
          SegmentedTabs(
            labels: const ['Foros', 'Mis grupos'],
            selected: _tab,
            onSelected: (index) => setState(() => _tab = index),
          ),
          const SizedBox(height: 16),
          if (_tab == 0) ..._forumsTab(provider) else ..._groupsTab(provider),
        ],
      ),
    );
  }
}
