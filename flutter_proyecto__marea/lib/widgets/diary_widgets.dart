import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../flows/notifications/screens/notifications_screen.dart';
import '../flows/profile/screens/profile_screen.dart';
import '../models/emotional_record.dart';
import '../services/quote_service.dart';
import 'user_avatar.dart';

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
                style: TextStyle(color: mutedColor(context), fontSize: 15),
              ),
            ],
          ),
        ),
        if (showProfile) ...[
          RoundIconButton(
            icon: Icons.notifications_none,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            icon: const UserAvatar(radius: 22, fontSize: 14),
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
    this.color,
    this.size = 20,
    this.weight = FontWeight.normal,
    this.italic = false,
  });
  final String text;
  final Color? color;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Muy bajo',
              style: TextStyle(color: mutedColor(context), fontSize: 12),
            ),
            Text(
              'Muy bien',
              style: TextStyle(color: mutedColor(context), fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

// Puntos de la semana actual (lunes a domingo) con el color del ánimo de
// cada día. Los días sin registro se ven apagados.
class WeekDots extends StatelessWidget {
  const WeekDots({super.key, required this.colors, required this.todayIndex});
  final List<Color?> colors;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    const labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < labels.length; i++)
          Column(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: colors[i] ?? const Color(0xFF40515A),
              ),
              const SizedBox(height: 7),
              Text(
                labels[i],
                style: TextStyle(
                  color: i == todayIndex ? teal : mutedColor(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// Frase del día, traída de una API por HTTP (QuoteService).
class Quote extends StatefulWidget {
  const Quote({super.key, this.alignedLeft = false});
  final bool alignedLeft;

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  late final Future<DailyQuote> _quote = QuoteService.today();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyQuote>(
      future: _quote,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 44);
        final quote = snapshot.data!;
        final align = widget.alignedLeft ? TextAlign.left : TextAlign.center;
        return Column(
          crossAxisAlignment: widget.alignedLeft
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              '“${quote.text}”',
              textAlign: align,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontFamilyFallback: const ['serif'],
                color: mutedColor(context),
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              [
                if (widget.alignedLeft) 'Frase del día',
                if (quote.author.isNotEmpty) quote.author,
              ].join(' · '),
              textAlign: align,
              style: TextStyle(color: mutedColor(context), fontSize: 12),
            ),
          ],
        );
      },
    );
  }
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
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: teal,
        foregroundColor: ink,
        elevation: 0,
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
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: selected ? teal : surfaceColor(context),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, color: selected ? ink : textColor(context)),
    ),
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

  List<Widget> _buildTabs(BuildContext context) {
    List<Widget> tabs = [];
    for (int i = 0; i < labels.length; i++) {
      tabs.add(
        Expanded(
          child: TextButton(
            onPressed: () => onSelected(i),
            style: TextButton.styleFrom(
              backgroundColor: selected == i ? teal : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              labels[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected == i ? ink : mutedColor(context),
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(children: _buildTabs(context)),
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
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      backgroundColor: surfaceColor(context),
      foregroundColor: textColor(context),
      padding: const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: mutedColor(context), fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                '${two(value.day)}/${two(value.month)}/${value.year}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Icon(
          Icons.calendar_today_outlined,
          color: mutedColor(context),
          size: 18,
        ),
      ],
    ),
  );
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record, required this.onTap});
  final EmotionalRecord record;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      backgroundColor: cream,
      foregroundColor: ink,
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
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
                    '${shortDay(record.date.weekday)} · ${record.date.day} ${shortMonth(record.date.month)}',
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF777269))),
        Text(
          value,
          style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

// Ánimo de cada día de la semana actual y promedio por día de la semana.
class WeeklyPattern extends StatelessWidget {
  const WeeklyPattern({super.key, required this.week, required this.averages});
  // Ánimo de lunes a domingo de esta semana (null = sin registro).
  final List<double?> week;
  // Promedio de todos los lunes, martes, etc. (null = sin registros).
  final List<double?> averages;

  static const _labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CreamCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ánimo de esta semana',
              style: TextStyle(color: ink, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: week.every((m) => m == null)
                  ? const Center(
                      child: Text(
                        'Aún no hay registros esta semana',
                        style: TextStyle(color: Color(0xFF777269)),
                      ),
                    )
                  : CustomPaint(painter: _WeekChartPainter(week)),
            ),
            const SizedBox(height: 8),
            // Cada letra va centrada en su columna, igual que los puntos.
            Row(
              children: [
                for (final label in _labels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF777269)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Promedio por día',
        style: TextStyle(color: mutedColor(context), fontSize: 12),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < 7; i++)
            Container(
              width: 43,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: averages[i] == null
                    ? const Color(0xFFDDD5C7)
                    : EmotionalRecord.colorForMood(averages[i]!),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                _labels[i],
                style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    ],
  );
}


// Dibuja la "marea" de la semana: una línea suave que pasa por los días con
// registro, el área de color debajo y un punto por día a la altura del ánimo.
class _WeekChartPainter extends CustomPainter {
  _WeekChartPainter(this.week);

  final List<double?> week;

  static const _pad = 12.0;

  Offset _point(int day, double mood, Size size) {
    final column = size.width / 7;
    final x = column * day + column / 2;
    final y = _pad + (1 - mood) * (size.height - 2 * _pad);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Líneas guía: muy bien, neutral y muy bajo.
    final guide = Paint()
      ..color = const Color(0xFFDDD5C7)
      ..strokeWidth = 1;
    for (final mood in [1.0, 0.5, 0.0]) {
      final y = _point(0, mood, size).dy;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), guide);
    }

    final points = <Offset>[];
    final moods = <double>[];
    for (var i = 0; i < week.length; i++) {
      final mood = week[i];
      if (mood == null) continue;
      points.add(_point(i, mood, size));
      moods.add(mood);
    }

    if (points.length >= 2) {
      // Curva suave entre puntos consecutivos.
      final line = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        final a = points[i - 1];
        final b = points[i];
        final midX = (a.dx + b.dx) / 2;
        line.cubicTo(midX, a.dy, midX, b.dy, b.dx, b.dy);
      }

      final bottom = size.height - _pad;
      final area = Path.from(line)
        ..lineTo(points.last.dx, bottom)
        ..lineTo(points.first.dx, bottom)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x80F18458), Color(0x66E2A655), Color(0x40647AA2)],
          ).createShader(Offset.zero & size),
      );
      canvas.drawPath(
        line,
        Paint()
          ..color = ink.withValues(alpha: .55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 8, Paint()..color = Colors.white);
      canvas.drawCircle(
        points[i],
        6,
        Paint()..color = EmotionalRecord.colorForMood(moods[i]),
      );
    }
  }

  @override
  bool shouldRepaint(_WeekChartPainter old) => old.week != week;
}

// Calendario de las últimas 4 semanas con el color del ánimo de cada día.
class MonthlyPattern extends StatelessWidget {
  const MonthlyPattern({super.key, required this.days});
  // 28 días, de lunes a domingo (null = sin registro).
  final List<Color?> days;

  @override
  Widget build(BuildContext context) {
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
          for (int week = 0; week < 4; week++)
            Row(
              children: [
                for (int day = 0; day < 7; day++)
                  Expanded(
                    child: Container(
                      height: 32,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: days[week * 7 + day] ?? cream,
                        border: days[week * 7 + day] == null
                            ? Border.all(
                                color: const Color(0xFFDDD5C7),
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
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

  Widget _buildOption(int index) {
    return TextButton(
      onPressed: () => onSelected(index),
      style: TextButton.styleFrom(
        backgroundColor: selected == index ? teal : Colors.white,
        foregroundColor: ink,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        side: BorderSide(
          color: selected == index ? teal : const Color(0xFFDDD5C7),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Row(
        children: [
          if (selected == index) const Icon(Icons.check, color: ink, size: 17),
          Expanded(
            child: Text(
              options[index],
              textAlign: TextAlign.center,
              style: const TextStyle(color: ink, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    for (int i = 0; i < options.length; i = i + 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(child: _buildOption(i)),
              const SizedBox(width: 8),
              Expanded(
                child: i + 1 < options.length
                    ? _buildOption(i + 1)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return rows;
  }

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
      ..._buildRows(),
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

const _months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String monthName(int month) => _months[month - 1];

String shortMonth(int month) => _months[month - 1].substring(0, 3);
