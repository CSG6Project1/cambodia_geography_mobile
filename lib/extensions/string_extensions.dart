extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  /// return 0 on given string is null;
  int onlyNumber() {
    var number = this.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(number) ?? 0;
  }
}
