import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../providers/notifications_provider.dart';
import '../../../providers/records_provider.dart';
import '../../../services/auth_service.dart';
import '../../../utils/mood_stats.dart';
import '../../../widgets/diary_widgets.dart';
import 'tracking_screen.dart';

// Registro del día: crea o edita el registro de hoy en Firestore.
class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double mood = 0.5;
  final noteController = TextEditingController();
  bool _editing = false;
  bool _saving = false;
  String? _filledFrom;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  String get feeling => EmotionalRecord.labelForMood(mood).toLowerCase();

  // Saluda con el primer nombre del usuario que inició sesión.
  String _greeting() {
    final name = AuthService.displayName;
    return name.isEmpty ? 'Hola' : 'Hola, ${name.split(' ').first}';
  }

  String _todayText(DateTime today) =>
      '${longDay(today.weekday)}, ${today.day} de ${monthName(today.month)}';

  // Pone en el formulario lo que ya estaba guardado hoy (una sola vez).
  void _fillFrom(EmotionalRecord? record) {
    final key = record?.dayKey ?? 'nuevo';
    if (_filledFrom == key) return;
    _filledFrom = key;
    mood = record?.mood ?? 0.5;
    noteController.text = record?.note ?? '';
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<RecordsProvider>().saveToday(
        mood: mood,
        note: noteController.text,
      );
      if (!mounted) return;
      setState(() {
        _saving = false;
        _editing = false;
      });
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Registro guardado')));
    } catch (e) {
      debugPrint('No se pudo guardar el registro: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar. Revisa tu conexión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = context.watch<RecordsProvider>();
    final todayRecord = records.todayRecord;
    final showForm = todayRecord == null || _editing;
    if (showForm) _fillFrom(todayRecord);

    return RefreshIndicator(
      onRefresh: records.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
        children: [
          showForm
              ? _formView(context, records)
              : _savedView(context, todayRecord),
        ],
      ),
    );
  }

  Widget _weekDots(RecordsProvider records) {
    final week = MoodStats.week(records.items, records.today);
    return WeekDots(
      colors: [for (final r in week) r?.color],
      todayIndex: records.today.weekday - 1,
    );
  }

  Widget _formView(BuildContext context, RecordsProvider records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TopHeader(
          title: _greeting(),
          subtitle: _todayText(records.today),
          showProfile: true,
        ),
        const SizedBox(height: 30),
        MoodSlider(
          value: mood,
          onChanged: (value) => setState(() => mood = value),
        ),
        const SizedBox(height: 24),
        Center(child: SerifText('Me siento $feeling', size: 26, italic: true)),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Desliza el punto en la marea para ajustar',
            style: TextStyle(color: mutedColor(context), fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),
        _weekDots(records),
        const SizedBox(height: 58),
        const Quote(),
        const SizedBox(height: 54),
        CreamCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SerifText(
                '¿Qué pasó hoy?',
                color: ink,
                size: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                minLines: 2,
                maxLines: 4,
                style: const TextStyle(color: ink, height: 1.45),
                decoration: InputDecoration(
                  hintText: 'Escribe lo que quieras recordar de hoy',
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .75),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFDDD5C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFDDD5C7)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: _saving ? 'Guardando...' : 'Guardar registro',
                onPressed: _saving ? () {} : _save,
              ),
              if (_editing) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _editing = false),
                  child: const Text('Cancelar'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _savedView(BuildContext context, EmotionalRecord record) {
    final unread = context.watch<NotificationsProvider>().unreadCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TopHeader(
          title: _greeting(),
          subtitle: _todayText(record.date),
          showProfile: true,
        ),
        const SizedBox(height: 24),
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 7, backgroundColor: record.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SerifText(
                      'Hoy te sientes ${record.moodLabel.toLowerCase()}',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _editing = true;
                      _filledFrom = null;
                    }),
                    child: const Text('Editar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MoodSlider(value: record.mood),
              if (record.note.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  record.note,
                  style: const TextStyle(
                    color: Color(0xFF777269),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrackingScreen()),
          ),
          style: TextButton.styleFrom(
            backgroundColor: surfaceColor(context),
            foregroundColor: textColor(context),
            padding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.monitor_heart_outlined),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seguimiento del día',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.energy == null
                          ? 'Energía, sueño y pensamientos'
                          : 'Energía ${record.energy!.toLowerCase()} · '
                                '${record.sleep?.toLowerCase() ?? ''}',
                      style: TextStyle(
                        color: mutedColor(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: mutedColor(context)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Quote(alignedLeft: true),
        const SizedBox(height: 22),
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SerifText(
                'Avisos',
                color: ink,
                size: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              Notice(
                icon: Icons.notifications_none,
                text: unread == 0
                    ? 'No tienes notificaciones nuevas'
                    : unread == 1
                    ? 'Tienes 1 notificación sin leer'
                    : 'Tienes $unread notificaciones sin leer',
              ),
              const SizedBox(height: 14),
              Notice(
                icon: Icons.local_fire_department_outlined,
                text: _streakText(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Días seguidos con registro, contando hasta hoy.
  String _streakText(BuildContext context) {
    final records = context.read<RecordsProvider>();
    var streak = 0;
    var day = records.today;
    while (records.byDay(day) != null) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return streak == 1
        ? 'Llevas 1 día seguido registrando cómo te sientes'
        : 'Llevas $streak días seguidos registrando cómo te sientes';
  }
}
