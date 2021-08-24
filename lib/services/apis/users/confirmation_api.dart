import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class ConfirmationApi extends BaseResourceOwnerApi<ConfirmationModel> {
  @override
  bool get useJapx => false;

  @override
  String get nameInUrl => "confirmation";

  Future<dynamic> confirmEmail() async {
    return await super.create(body: {});
  }

  @override
  ConfirmationModel objectTransformer(Map<String, dynamic> json) {
    return ConfirmationModel.fromJson(json);
  }
}
