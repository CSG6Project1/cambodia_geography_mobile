import 'package:cambodia_geography/services/locale/locale_format_service.dart';
import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._internal();

  /// `1990-01-01`
  static DateTime stringToDate(String string) {
    final DateTime dateTime = DateFormat("yyyy-MM-dd").parse(string);
    return dateTime;
  }

  /// `1990-01-01`
  static String dateToString(DateTime date) {
    final String string = DateFormat("yyyy-MM-dd").format(date);
    return string;
  }

  static String displayDateByDate(DateTime date, {String locale = 'en'}) {
    String dateFormat = LocaleFormatService(locale).dateFormat();
    return DateFormat(dateFormat, locale).format(date.toLocal()).toString();
  }

  static String displayDateByStr(String date, {String locale = 'en'}) {
    String dateFormat = LocaleFormatService(locale).dateFormat();
    return DateFormat(dateFormat, locale).format(DateTime.parse(date).toLocal()).toString();
  }
}
