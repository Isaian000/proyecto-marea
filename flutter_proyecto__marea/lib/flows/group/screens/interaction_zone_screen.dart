import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

import '../../../core/app_colors.dart';
import '../../../models/group_models.dart';
import '../../../widgets/group_widgets.dart';
import 'chat_screen.dart';

class InteractionZoneScreen extends StatelessWidget {
  const InteractionZoneScreen({super.key});

  void _openChat(BuildContext context, ChatScreen chat) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => chat));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          children: [
            const PageHeader(
              title: 'Zona de interacción',
              subtitle: 'Conecta con otras personas del grupo',
            ),
            const SizedBox(height: 18),
            Text(
              'Perfiles sugeridos',
              style: TextStyle(color: mutedColor(context), fontSize: 14),
            ),
            const SizedBox(height: 12),
            SuggestedProfileCard(
              name: 'Javier Salas',
              status: 'Disponible para platicar',
              initials: 'JS',
              color: slate,
              online: true,
              onChat: () => _openChat(
                context,
                const ChatScreen(
                  title: 'Javier Salas',
                  subtitle: 'ID: GS572H',
                  initials: 'JS',
                  color: slate,
                  hint: 'Escribe un mensaje',
                  messages: [
                    ChatMessage(
                      text: 'Hola, me interesó tu perfil, mucho gusto',
                      isMine: false,
                    ),
                    ChatMessage(text: 'Hola, mucho gusto', isMine: true),
                    ChatMessage(
                      text: '¿Quieres platicar sobre algún tema?',
                      isMine: false,
                    ),
                    ChatMessage(text: 'Sí, claro', isMine: true),
                  ],
                ),
              ),
            ),
            SuggestedProfileCard(
              name: 'Valeria Roma',
              status: 'Necesito platicar',
              initials: 'VR',
              color: gold,
              online: true,
              onChat: () => _openChat(
                context,
                const ChatScreen(
                  title: 'Valeria Roma',
                  subtitle: 'ID: VR218K',
                  initials: 'VR',
                  color: gold,
                  hint: 'Escribe un mensaje',
                ),
              ),
            ),
            SuggestedProfileCard(
              name: 'Diego Leal',
              status: 'Descansando',
              initials: 'DL',
              color: sand,
              online: false,
              onChat: () => _openChat(
                context,
                const ChatScreen(
                  title: 'Diego Leal',
                  subtitle: 'ID: DL904P',
                  initials: 'DL',
                  color: sand,
                  hint: 'Escribe un mensaje',
                ),
              ),
            ),
            const SizedBox(height: 4),
            GlobalChatCard(
              onPressed: () => _openChat(
                context,
                const ChatScreen(
                  title: 'Grupo General',
                  color: gold,
                  isGroup: true,
                  hint: 'Escribe algo',
                  messages: [
                    ChatMessage(
                      text: 'Hola, buenas tardes. Un gusto estar por aquí',
                      isMine: false,
                      author: 'José',
                    ),
                    ChatMessage(
                      text: '¿Es la primera vez que entras?',
                      isMine: false,
                      author: 'Álvaro',
                    ),
                    ChatMessage(
                      text: 'Yo soy nueva por aquí',
                      isMine: false,
                      author: 'María',
                    ),
                    ChatMessage(text: 'Yo también', isMine: true, author: 'Tú'),
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
