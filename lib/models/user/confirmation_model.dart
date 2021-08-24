import 'package:json_annotation/json_annotation.dart';
part 'confirmation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ConfirmationModel {
  String? message;
  String? expiresIn;

  ConfirmationModel({
    this.message,
    this.expiresIn,
  });

  factory ConfirmationModel.fromJson(Map<String, dynamic> json) => _$ConfirmationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConfirmationModelToJson(this);
}
