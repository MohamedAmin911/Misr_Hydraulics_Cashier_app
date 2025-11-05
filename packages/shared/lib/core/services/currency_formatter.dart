import 'package:intl/intl.dart';
import '../app_config.dart';

class CurrencyFormatter {
  static String format(num value) {
    final nf = NumberFormat.currency(
      locale: AppConfig.currencyLocale,
      symbol: AppConfig.currencySymbol,
      decimalDigits: AppConfig.currencyDecimalDigits,
    );
    return nf.format(value);
  }
}
