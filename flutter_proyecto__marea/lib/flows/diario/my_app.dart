import 'package:flutter/material.dart';

import 'emotional_record.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';
import '../comunity/groups.dart';
import '../onBoarding/onBoarding.dart';

const navy = Color(0xFF1D2B33);
const navyLight = Color(0xFF253943);
const cream = Color(0xFFF5F1E8);
const ink = Color(0xFF263037);
const muted = Color(0xFFA8B7BA);
const teal = Color(0xFF79B4A4);
const gold = Color(0xFFE2A655);
const orange = Color(0xFFF18458);
const blue = Color(0xFF647AA2);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          brightness: Brightness.dark,
          surface: navy,
        ),
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: cream),
          bodyMedium: TextStyle(color: cream),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class DiaryShell extends StatefulWidget {
  const DiaryShell({super.key});

  @override
  State<DiaryShell> createState() => _DiaryShellState();
}

class _DiaryShellState extends State<DiaryShell> {
  int selectedIndex = 0;
  bool recordSaved = false;
  double mood = 0.72;
  String note =
      'Reunión larga en la mañana, pero salí a caminar 20 min y bajé el estrés.';

  final records = <EmotionalRecord>[
    EmotionalRecord(
      date: DateTime(2025, 9, 5),
      mood: .72,
      moodLabel: 'Bien',
      note: 'Reunión larga en la mañana, pero salí a caminar 20 min y bajé el estrés.',
      color: gold,
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 4),
      mood: .73,
      moodLabel: 'Bien',
      note: 'Terminé una tarea pendiente, se sintió bien avanzar.',
      color: gold,
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 3),
      mood: .50,
      moodLabel: 'Neutral',
      note: 'Día normal, sin sobresaltos.',
      color: Color(0xFFBEAF8B),
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 2),
      mood: .30,
      moodLabel: 'Bajo',
      note: 'Dormí poco, día lento en general.',
      color: Color(0xFF829DB6),
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 1),
      mood: .18,
      moodLabel: 'Ansioso',
      note: 'Junta de proyecto se movió otra vez, cuesta empezar la semana.',
      color: blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      TodayPage(
        saved: recordSaved,
        initialMood: mood,
        initialNote: note,
        onSave: (newMood, newNote) {
          setState(() {
            mood = newMood;
            note = newNote;
            recordSaved = true;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Registro guardado')));
        },
      ),
      HistoryPage(records: records),
      const PatternsPage(),
      const CommunityForumsPage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: NavigationBar(
        height: 82,
        backgroundColor: navy,
        indicatorColor: teal,
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Hoy',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Patrones',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Comunidad',
          ),
        ],
      ),
    );
  }
}

class TodayPage extends StatefulWidget {
  const TodayPage({
    super.key,
    required this.saved,
    required this.initialMood,
    required this.initialNote,
    required this.onSave,
  });

  final bool saved;
  final double initialMood;
  final String initialNote;
  final void Function(double mood, String note) onSave;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late double mood;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    mood = widget.initialMood;
    noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  String get feeling {
    if (mood < .25) return 'muy bajo';
    if (mood < .45) return 'bajo';
    if (mood < .65) return 'neutral';
    if (mood < .85) return 'bien';
    return 'muy bien';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: widget.saved ? _savedView(context) : _formView(context),
    );
  }

  Widget _formView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TopHeader(
          title: 'Hola, Elena',
          subtitle: 'Viernes, 5 de septiembre',
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
        const Center(
          child: Text(
            'Desliza el punto en la marea para ajustar',
            style: TextStyle(color: muted, fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),
        const WeekDots(),
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
                label: 'Guardar registro',
                onPressed: () =>
                    widget.onSave(mood, noteController.text.trim()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _savedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 7, backgroundColor: gold),
                  const SizedBox(width: 10),
                  SerifText(
                    'Hoy te sientes $feeling',
                    color: ink,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MoodSlider(value: mood),
              const SizedBox(height: 14),
              Text(
                noteController.text,
                style: const TextStyle(color: Color(0xFF777269), height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrackingPage()),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: navyLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.monitor_heart_outlined),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seguimiento del día',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Energía, sueño y pensamientos',
                        style: TextStyle(color: muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: muted),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Quote(alignedLeft: true),
        const SizedBox(height: 22),
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SerifText(
                'Avisos',
                color: ink,
                size: 18,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 12),
              Notice(
                icon: Icons.menu_book_outlined,
                text: 'Nuevo recurso: Técnicas de respiración',
              ),
              SizedBox(height: 14),
              Notice(
                icon: Icons.chat_bubble_outline,
                text: '2 mensajes nuevos en tu grupo',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.records});

  final List<EmotionalRecord> records;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int period = 0;
  bool dateFilter = false;
  DateTime from = DateTime(2025, 9, 1);
  DateTime to = DateTime(2025, 9, 3);

  List<EmotionalRecord> get visibleRecords {
    if (!dateFilter) return widget.records;
    return widget.records
        .where((item) => !item.date.isBefore(from) && !item.date.isAfter(to))
        .toList();
  }

  Future<void> pickDate(bool isFrom) async {
    final current = isFrom ? from : to;
    final selected = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (selected != null) {
      setState(() {
        if (isFrom) {
          from = selected;
        } else {
          to = selected;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = visibleRecords;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      'Historial',
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFilter
                          ? '${shown.length} registros entre estas fechas'
                          : '5 registros esta semana',
                      style: const TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
              RoundIconButton(
                icon: Icons.calendar_month_outlined,
                selected: dateFilter,
                onPressed: () => setState(() => dateFilter = !dateFilter),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SegmentedTabs(
            labels: const ['Semana', 'Mes', 'Todo'],
            selected: period,
            onSelected: (value) => setState(() => period = value),
          ),
          if (dateFilter) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DateBox(
                    label: 'Desde',
                    value: from,
                    onTap: () => pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DateBox(
                    label: 'Hasta',
                    value: to,
                    onTap: () => pickDate(false),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          ...shown.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecordCard(
                record: record,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordDetailPage(record: record),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({super.key, required this.record});

  final EmotionalRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RoundIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 18),
              SerifText(
                '${longDay(record.date.weekday)}, ${record.date.day} de septiembre',
                size: 27,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              const Text('Tu registro del día', style: TextStyle(color: muted)),
              const SizedBox(height: 26),
              MoodSlider(value: record.mood),
              const SizedBox(height: 20),
              Center(
                child: SerifText(
                  'Me sentí ${record.moodLabel.toLowerCase()}',
                  size: 26,
                  italic: true,
                ),
              ),
              const SizedBox(height: 36),
              CreamCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      '¿Qué pasó?',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      record.note,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CreamCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      'Seguimiento',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    DetailRow(label: 'Energía', value: record.energy),
                    DetailRow(label: 'Sueño', value: record.sleep),
                    DetailRow(
                      label: 'Pensamientos',
                      value: record.thoughts,
                      divider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatternsPage extends StatefulWidget {
  const PatternsPage({super.key});

  @override
  State<PatternsPage> createState() => _PatternsPageState();
}

class _PatternsPageState extends State<PatternsPage> {
  int period = 0;
  final colors = const [
    blue,
    Color(0xFF829DB6),
    Color(0xFFBEAF8B),
    gold,
    Color(0xFF829DB6),
    gold,
    orange,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopHeader(
            title: 'Patrones',
            subtitle: 'Tu marea emocional',
            showProfile: true,
          ),
          const SizedBox(height: 20),
          SegmentedTabs(
            labels: const ['Semana', 'Mes', 'Todo'],
            selected: period,
            onSelected: (value) => setState(() => period = value),
          ),
          const SizedBox(height: 14),
          if (period == 0)
            WeeklyPattern(colors: colors)
          else
            MonthlyPattern(colors: colors),
          const SizedBox(height: 14),
          CreamCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE6E4E2),
                  child: Icon(Icons.auto_awesome, color: blue),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SerifText(
                        'Patrón detectado',
                        color: ink,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sueles sentirte más bajo los lunes y más cansado los viernes.',
                        style: TextStyle(color: ink, height: 1.4),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Basado en tus últimos 30 registros',
                        style: TextStyle(
                          color: Color(0xFF777269),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  int energy = 2;
  int sleep = 2;
  int thoughts = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RoundIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SerifText(
                    'Seguimiento',
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tres preguntas rápidas sobre tu día',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChoiceGroup(
                        question: '¿Cómo fue tu energía durante el día?',
                        options: const [
                          'Muy baja',
                          'Baja',
                          'Activa',
                          'Muy activa',
                        ],
                        selected: energy,
                        onSelected: (value) => setState(() => energy = value),
                      ),
                      const SizedBox(height: 24),
                      ChoiceGroup(
                        question: '¿Cómo calificas tu sueño de anoche?',
                        options: const [
                          'No dormí casi nada',
                          'Dormí poco',
                          'Dormí lo necesario',
                          'Dormí excelente',
                        ],
                        selected: sleep,
                        onSelected: (value) => setState(() => sleep = value),
                      ),
                      const SizedBox(height: 24),
                      ChoiceGroup(
                        question: '¿Cómo fueron tus pensamientos hoy?',
                        options: const [
                          'Negativos',
                          'Algo negativos',
                          'Neutrales',
                          'Positivos',
                        ],
                        selected: thoughts,
                        onSelected: (value) => setState(() => thoughts = value),
                      ),
                      const SizedBox(height: 60),
                      PrimaryButton(
                        label: 'Guardar seguimiento',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seguimiento guardado'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showProfile = false,
  });
  final String title;
  final String subtitle;
  final bool showProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SerifText(title, size: 28, weight: FontWeight.bold),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 15),
              ),
            ],
          ),
        ),
        if (showProfile) ...[
          RoundIconButton(
            icon: Icons.notifications_none,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: gold,
              child: Text(
                'EM',
                style: TextStyle(color: ink, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SerifText extends StatelessWidget {
  const SerifText(
    this.text, {
    super.key,
    this.color = cream,
    this.size = 20,
    this.weight = FontWeight.normal,
    this.italic = false,
  });
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final bool italic;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Georgia',
      fontFamilyFallback: const ['serif'],
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      height: 1.25,
    ),
  );
}

class CreamCard extends StatelessWidget {
  const CreamCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: cream,
      borderRadius: BorderRadius.circular(22),
    ),
    child: child,
  );
}

class MoodSlider extends StatelessWidget {
  const MoodSlider({super.key, required this.value, this.onChanged});
  final double value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 64,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.white,
            overlayColor: Colors.white24,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  gradient: const LinearGradient(
                    colors: [
                      blue,
                      Color(0xFF92A7B7),
                      Color(0xFFC7B48D),
                      gold,
                      orange,
                    ],
                  ),
                ),
              ),
              Slider(value: value, onChanged: onChanged ?? (_) {}),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Muy bajo', style: TextStyle(color: muted, fontSize: 12)),
            Text('Muy bien', style: TextStyle(color: muted, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class WeekDots extends StatelessWidget {
  const WeekDots({super.key});
  @override
  Widget build(BuildContext context) {
    const labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    const colors = [
      blue,
      Color(0xFF829DB6),
      Color(0xFFBEAF8B),
      gold,
      teal,
      Color(0xFF40515A),
      Color(0xFF40515A),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        labels.length,
        (index) => Column(
          children: [
            CircleAvatar(radius: 5, backgroundColor: colors[index]),
            const SizedBox(height: 7),
            Text(
              labels[index],
              style: TextStyle(color: index == 4 ? teal : muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class Quote extends StatelessWidget {
  const Quote({super.key, this.alignedLeft = false});
  final bool alignedLeft;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: alignedLeft
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center,
    children: [
      const SerifText(
        '“Está bien no estar bien. Lo importante es\nseguir adelante.”',
        color: muted,
        size: 16,
        italic: true,
      ),
      if (alignedLeft) ...[
        const SizedBox(height: 8),
        const Text(
          'Frase del día',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ],
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: teal,
        foregroundColor: ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.selected = false,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final bool selected;
  @override
  Widget build(BuildContext context) => IconButton.filled(
    style: IconButton.styleFrom(
      backgroundColor: selected ? teal : navyLight,
      foregroundColor: selected ? ink : cream,
    ),
    onPressed: onPressed ?? () {},
    icon: Icon(icon),
  );
}

class Notice extends StatelessWidget {
  const Notice({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Color(0xFF777269), size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(text, style: const TextStyle(color: ink, fontSize: 13)),
      ),
    ],
  );
}

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: navyLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: selected == index ? teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected == index ? ink : muted,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  const DateBox({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: navyLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: muted, fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  '${two(value.day)}/${two(value.month)}/${value.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.calendar_today_outlined, color: muted, size: 18),
        ],
      ),
    ),
  );
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record, required this.onTap});
  final EmotionalRecord record;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: CreamCard(
      child: Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: record.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${shortDay(record.date.weekday)} · ${record.date.day} sep',
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      record.moodLabel,
                      style: const TextStyle(
                        color: Color(0xFF777269),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  record.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF777269),
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF777269)),
        ],
      ),
    ),
  );
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.divider = true,
  });
  final String label;
  final String value;
  final bool divider;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      border: divider
          ? const Border(bottom: BorderSide(color: Color(0xFFDDD5C7)))
          : null,
    ),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF777269))),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class WeeklyPattern extends StatelessWidget {
  const WeeklyPattern({super.key, required this.colors});
  final List<Color> colors;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CreamCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ánimo semanal',
              style: TextStyle(color: ink, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 45,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x99647AA2),
                            Color(0x99E2A655),
                            Color(0x99F18458),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(colors.length, (index) {
                      final heights = [
                        50.0,
                        65.0,
                        82.0,
                        110.0,
                        66.0,
                        110.0,
                        126.0,
                      ];
                      return Padding(
                        padding: EdgeInsets.only(bottom: heights[index]),
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: colors[index],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('L', style: TextStyle(color: Color(0xFF777269))),
                Text('M', style: TextStyle(color: Color(0xFF777269))),
                Text('M', style: TextStyle(color: Color(0xFF777269))),
                Text('J', style: TextStyle(color: Color(0xFF777269))),
                Text('V', style: TextStyle(color: Color(0xFF777269))),
                Text('S', style: TextStyle(color: Color(0xFF777269))),
                Text('D', style: TextStyle(color: Color(0xFF777269))),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Promedio por día',
        style: TextStyle(color: muted, fontSize: 12),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          colors.length,
          (index) => Container(
            width: 43,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              const ['L', 'M', 'M', 'J', 'V', 'S', 'D'][index],
              style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ],
  );
}

class MonthlyPattern extends StatelessWidget {
  const MonthlyPattern({super.key, required this.colors});
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    final dots = <Color?>[
      ...colors,
      const Color(0xFF829DB6),
      const Color(0xFF829DB6),
      const Color(0xFFBEAF8B),
      const Color(0xFFBEAF8B),
      const Color(0xFF829DB6),
      orange,
      gold,
      blue,
      const Color(0xFFBEAF8B),
      const Color(0xFFBEAF8B),
      gold,
      const Color(0xFFBEAF8B),
      gold,
      gold,
      const Color(0xFF829DB6),
      const Color(0xFFBEAF8B),
      gold,
      gold,
      const Color(0xFF829DB6),
      null,
      null,
    ];
    return CreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Últimas 4 semanas',
            style: TextStyle(color: ink, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('L', style: TextStyle(color: Color(0xFF777269))),
              Text('M', style: TextStyle(color: Color(0xFF777269))),
              Text('M', style: TextStyle(color: Color(0xFF777269))),
              Text('J', style: TextStyle(color: Color(0xFF777269))),
              Text('V', style: TextStyle(color: Color(0xFF777269))),
              Text('S', style: TextStyle(color: Color(0xFF777269))),
              Text('D', style: TextStyle(color: Color(0xFF777269))),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: dots.length,
            itemBuilder: (_, index) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dots[index] ?? cream,
                border: dots[index] == null
                    ? Border.all(color: const Color(0xFFDDD5C7), width: 2)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [blue, Color(0xFFBEAF8B), gold, orange],
              ),
            ),
          ),
          const SizedBox(height: 7),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Muy bajo',
                style: TextStyle(color: Color(0xFF777269), fontSize: 11),
              ),
              Text(
                'Muy bien',
                style: TextStyle(color: Color(0xFF777269), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChoiceGroup extends StatelessWidget {
  const ChoiceGroup({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelected,
  });
  final String question;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: const TextStyle(
          color: ink,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      const SizedBox(height: 10),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemCount: options.length,
        itemBuilder: (_, index) => InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () => onSelected(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected == index ? teal : Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: selected == index ? teal : const Color(0xFFDDD5C7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selected == index) ...[
                  const Icon(Icons.check, color: ink, size: 17),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    options[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ink, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

String two(int value) => value.toString().padLeft(2, '0');

String shortDay(int day) =>
    const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][day - 1];

String longDay(int day) => const [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
][day - 1];
