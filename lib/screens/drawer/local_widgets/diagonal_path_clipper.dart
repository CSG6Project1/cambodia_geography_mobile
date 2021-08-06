import 'package:cambodia_geography/exports/exports.dart';

/// auto generate by https://fluttershapemaker.com
class DiagonalPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.007067622);
    path_0.lineTo(size.width, size.height * 0.9999990);
    path_0.lineTo(size.width * 0.03633341, size.height * 0.9999990);
    path_0.lineTo(0, size.height * 0.2619847);
    path_0.lineTo(size.width, size.height * 0.007067622);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
