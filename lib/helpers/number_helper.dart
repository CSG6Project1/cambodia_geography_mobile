class NumberHelper {
  static String toKhmer(dynamic number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const khmer = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
    String numConvert = '$number';
    for (int i = 0; i < english.length; i++) {
      numConvert = numConvert.replaceAll(english[i], khmer[i]);
    }
    return numConvert;
  }
}
