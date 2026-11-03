/// Word reveal positions measured against the prepared narration asset.
class ReadingTiming {
  ReadingTiming({
    required this.key,
    required this.locale,
    required this.text,
    required this.duration,
    required this.cues,
  });

  factory ReadingTiming.fromJson(Map<String, dynamic> json) => ReadingTiming(
    key: json['key'] as String,
    locale: json['locale'] as String,
    text: json['text'] as String,
    duration: Duration(
      microseconds: ((json['duration'] as num) * 1000000).round(),
    ),
    cues: [
      for (final cue in json['cues'] as List<dynamic>)
        ReadingCue(
          end: cue['end'] as int,
          time: Duration(
            microseconds: ((cue['time'] as num) * 1000000).round(),
          ),
        ),
    ],
  );

  final String key, locale, text;
  final Duration duration;
  final List<ReadingCue> cues;

  String visibleText(Duration position) {
    var end = 0;
    for (final cue in cues) {
      if (cue.time > position) break;
      end = cue.end;
    }
    return text.substring(0, end);
  }
}

class ReadingCue {
  const ReadingCue({required this.end, required this.time});
  final int end;
  final Duration time;
}
