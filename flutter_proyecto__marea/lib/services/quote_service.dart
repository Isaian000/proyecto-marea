import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DailyQuote {
  const DailyQuote(this.text, this.author);
  final String text;
  final String author;
}

// Frase del día desde una API pública en español (llamada HTTP).
// Se usan solo las frases no religiosas y cambia una vez al día.
class QuoteService {
  QuoteService._();

  static const url = 'https://gomezmig03.github.io/MotivationalAPI/es.json';

  static const fallback = DailyQuote(
    'Está bien no estar bien. Lo importante es seguir adelante.',
    '',
  );

  static Future<DailyQuote>? _cached;
  static String? _cachedDay;

  static Future<DailyQuote> today() {
    final now = DateTime.now();
    final day = '${now.year}-${now.month}-${now.day}';
    if (_cached == null || _cachedDay != day) {
      _cachedDay = day;
      _cached = fetch(http.Client(), now);
    }
    return _cached!;
  }

  static Future<DailyQuote> fetch(http.Client client, DateTime now) async {
    try {
      final response = await client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return fallback;
      return pickForDay(jsonDecode(utf8.decode(response.bodyBytes)), now);
    } catch (e) {
      debugPrint('No se pudo obtener la frase del día: $e');
      return fallback;
    } finally {
      client.close();
    }
  }

  static DailyQuote pickForDay(Object? data, DateTime now) {
    if (data is! List) return fallback;
    final secular = data
        .whereType<Map>()
        .where(
          (q) =>
              q['religion'] == 0 &&
              q['phrase'] is String &&
              (q['phrase'] as String).trim().isNotEmpty,
        )
        .toList();
    if (secular.isEmpty) return fallback;
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final quote = secular[dayOfYear % secular.length];
    return DailyQuote(
      (quote['phrase'] as String).trim().replaceAll(RegExp(r'\s+'), ' '),
      (quote['author'] as String? ?? '').trim(),
    );
  }
}
