class TbVillageModel {
  TbVillageModel({
    this.id,
    this.communeCode,
    this.code,
    this.khmer,
    this.english,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  String? communeCode;
  String? code;
  String? khmer;
  String? english;
  String? reference;
  String? officialNote;
  String? noteByChecker;

  factory TbVillageModel.fromJson(Map<String, dynamic> json) {
    return TbVillageModel(
      id: json["id"],
      communeCode: json["commune_code"],
      code: json["code"],
      khmer: json["khmer"],
      english: json["english"],
      reference: json["reference"],
      officialNote: json["official_note"],
      noteByChecker: json["note_by_checker"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "commune_code": communeCode,
      "code": code,
      "khmer": khmer,
      "english": english,
      "reference": reference,
      "official_note": officialNote,
      "note_by_checker": noteByChecker,
    };
  }
}
