import 'package:cambodia_geography/cambodia_geography.dart';

void main() async {
  final geo = CambodiaGeography();
  await geo.initilize();

  final list = geo.villagesSearch(communeCode: "080412");
  list.forEach((e) {
    print(e.toJson());
  });
}
