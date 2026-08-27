class AppDateUtils {
  AppDateUtils._();

  /// 1-based day of year for the given [date].
  static int dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }
}
