// lib/core/utils/duration_formatter.dart

class DurationFormatter {
  DurationFormatter._();

  /// "01:30:05"
  static String hhmmss(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// "1:30" si < 1h, "1:30:05" sinon
  static String smart(Duration d) {
    if (d.inHours > 0) return hhmmss(d);
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// "5 min", "1h 30min", "2h"
  static String human(Duration d) {
    if (d.inHours > 0 && d.inMinutes % 60 == 0) return '${d.inHours}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}min';
    if (d.inMinutes > 0 && d.inSeconds % 60 == 0) return '${d.inMinutes} min';
    if (d.inMinutes > 0) return '${d.inMinutes}min ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}
