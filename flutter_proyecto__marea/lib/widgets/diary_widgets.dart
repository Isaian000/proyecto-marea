import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../flows/notifications/screens/notifications_screen.dart';
import '../flows/profile/screens/profile_screen.dart';
import '../models/emotional_record.dart';

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
            icon: const CircleAvatar(
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

class WeekDots extends StatelessWidget {
  const WeekDots({super.key});

  List<Widget> _buildDays(BuildContext context) {
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
    List<Widget> days = [];
    for (int i = 0; i < labels.length; i++) {
      days.add(
        Column(
          children: [
            CircleAvatar(radius: 5, backgroundColor: colors[i]),
            const SizedBox(height: 7),
            Text(
              labels[i],
              style: TextStyle(
                color: i == 4 ? teal : mutedColor(context),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildDays(context),
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
      SerifText(
        '“Está bien no estar bien. Lo importante es\nseguir adelante.”',
        color: mutedColor(context),
        size: 16,
        italic: true,
      ),
      if (alignedLeft) ...[
        const SizedBox(height: 8),
        Text(
          'Frase del día',
          style: TextStyle(color: mutedColor(context), fontSize: 12),
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

class WeeklyPattern extends StatelessWidget {
  const WeeklyPattern({super.key, required this.colors});
  final List<Color> colors;
  List<Widget> _buildMoodDots() {
    const heights = [50.0, 65.0, 82.0, 110.0, 66.0, 110.0, 126.0];
    List<Widget> dots = [];
    for (int i = 0; i < colors.length; i++) {
      dots.add(
        Padding(
          padding: EdgeInsets.only(bottom: heights[i]),
          child: CircleAvatar(radius: 7, backgroundColor: colors[i]),
        ),
      );
    }
    return dots;
  }

  List<Widget> _buildAverages() {
    const labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    List<Widget> averages = [];
    for (int i = 0; i < colors.length; i++) {
      averages.add(
        Container(
          width: 43,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors[i],
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            labels[i],
            style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return averages;
  }

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
                    children: _buildMoodDots(),
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
      Text(
        'Promedio por día',
        style: TextStyle(color: mutedColor(context), fontSize: 12),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildAverages(),
      ),
    ],
  );
}

class MonthlyPattern extends StatelessWidget {
  const MonthlyPattern({super.key, required this.colors});
  final List<Color> colors;

  List<Widget> _buildWeeks(List<Color?> dots) {
    List<Widget> weeks = [];
    for (int week = 0; week < 4; week++) {
      List<Widget> days = [];
      for (int day = 0; day < 7; day++) {
        Color? color = dots[week * 7 + day];
        days.add(
          Expanded(
            child: Container(
              height: 32,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? cream,
                border: color == null
                    ? Border.all(color: const Color(0xFFDDD5C7), width: 2)
                    : null,
              ),
            ),
          ),
        );
      }
      weeks.add(Row(children: days));
    }
    return weeks;
  }

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
          ..._buildWeeks(dots),
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
