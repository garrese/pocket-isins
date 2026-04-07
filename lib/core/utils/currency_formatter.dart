class CurrencyFormatter {
  static String format(num value) {
    if (value >= 10000 || value <= -10000) {
      return value.truncate().toString();
    }
    return value.toStringAsFixed(2);
  }
}
