class TbProvinceModel {
  TbProvinceModel({
    this.id,
    this.code,
    this.khmer,
    this.english,
    this.krong,
    this.srok,
    this.khan,
    this.commune,
    this.sangkat,
    this.village,
    this.reference,
    this.latitude,
    this.longitudes,
    this.abbreviation,
    this.eastEn,
    this.eastKh,
    this.westEn,
    this.westKh,
    this.southEn,
    this.southKh,
    this.northEn,
    this.northKh,
  });

  int? id;
  String? code;
  String? khmer;
  String? english;
  int? krong;
  int? srok;
  int? khan;
  int? commune;
  int? sangkat;
  int? village;
  String? reference;
  String? latitude;
  String? longitudes;
  String? abbreviation;
  String? eastEn;
  String? eastKh;
  String? westEn;
  String? westKh;
  String? southEn;
  String? southKh;
  String? northEn;
  String? northKh;

  factory TbProvinceModel.fromJson(Map<String, dynamic> json) {
    return TbProvinceModel(
      id: json["id"],
      code: json["code"],
      khmer: json["khmer"],
      english: json["english"],
      krong: json["krong"],
      srok: json["srok"],
      khan: json["khan"],
      commune: json["commune"],
      sangkat: json["sangkat"],
      village: json["village"],
      reference: json["reference"],
      latitude: json["latitude"],
      longitudes: json["longitudes"],
      abbreviation: json["abbreviation"],
      eastEn: json["east_en"],
      eastKh: json["east_kh"],
      westEn: json["west_en"],
      westKh: json["west_kh"],
      southEn: json["south_en"],
      southKh: json["south_kh"],
      northEn: json["north_en"],
      northKh: json["north_kh"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "khmer": khmer,
      "english": english,
      "krong": krong,
      "srok": srok,
      "khan": khan,
      "commune": commune,
      "sangkat": sangkat,
      "village": village,
      "reference": reference,
      "latitude": latitude,
      "longitudes": longitudes,
      "abbreviation": abbreviation,
      "east_en": eastEn,
      "east_kh": eastKh,
      "west_en": westEn,
      "west_kh": westKh,
      "south_en": southEn,
      "south_kh": southKh,
      "north_en": northEn,
      "north_kh": northKh,
    };
  }
}
