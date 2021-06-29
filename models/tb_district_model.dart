class TbDistrictModel {
  TbDistrictModel({
    this.id,
    this.provinceCode,
    this.code,
    this.type,
    this.khmer,
    this.english,
    this.commune,
    this.sangkat,
    this.village,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  String? provinceCode;
  String? code;
  String? type;
  String? khmer;
  String? english;
  int? commune;
  int? sangkat;
  int? village;
  String? reference;
  String? officialNote;
  String? noteByChecker;

  factory TbDistrictModel.fromJson(Map<String, dynamic> json) {
    return TbDistrictModel(
      id: json["id"],
      provinceCode: json["province_code"],
      code: json["code"],
      type: json["type"],
      khmer: json["khmer"],
      english: json["english"],
      commune: json["commune"],
      sangkat: json["sangkat"],
      village: json["village"],
      reference: json["reference"],
      officialNote: json["official_note"],
      noteByChecker: json["note_by_checker"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "province_code": provinceCode,
      "code": code,
      "type": type,
      "khmer": khmer,
      "english": english,
      "commune": commune,
      "sangkat": sangkat,
      "village": village,
      "reference": reference,
      "official_note": officialNote,
      "note_by_checker": noteByChecker,
    };
  }
}
