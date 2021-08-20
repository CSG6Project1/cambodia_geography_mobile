class LocaleFormatService {
  final String locale;

  LocaleFormatService(this.locale);

  dateFormat() {
    switch (this.locale) {
      case 'km':
        return 'dd MMM yyyy, hh:mm a';
      case 'zh':
        return 'yyyy-MM-dd, hh:mm a';
      case 'vi':
        return 'dd MMM yyyy, hh:mm a';
      default:
        return 'MMM dd, yyyy, hh:mm a';
    }
  }
}
