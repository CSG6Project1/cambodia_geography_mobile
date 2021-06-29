class TbCommuneModel {
  TbCommuneModel({
    this.id,
    this.districtCode,
    this.code,
    this.type,
    this.khmer,
    this.english,
    this.village,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  String? districtCode;
  String? code;
  String? type;
  String? khmer;
  String? english;
  int? village;
  String? reference;
  String? officialNote;
  String? noteByChecker;

  factory TbCommuneModel.fromJson(Map<String, dynamic> json) {
    return TbCommuneModel(
      id: json["id"],
      districtCode: json["district_code"],
      code: json["code"],
      type: json["type"],
      khmer: json["khmer"],
      english: json["english"],
      village: json["village"],
      reference: json["reference"],
      officialNote: json["official_note"],
      noteByChecker: json["note_by_checker"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "district_code": districtCode,
      "code": code,
      "type": type,
      "khmer": khmer,
      "english": english,
      "village": village,
      "reference": reference,
      "official_note": officialNote,
      "note_by_checker": noteByChecker,
    };
  }
}
