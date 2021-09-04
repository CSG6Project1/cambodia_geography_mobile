import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class UserAccountLinkagesApi extends BaseResourceOwnerApi {
  @override
  bool get useJapx => false;

  @override
  String get nameInUrl => "user_account_linkages";

  Future<dynamic> disconnectAnAccountLinkage(String provider) async {
    return await super.delete(id: provider);
  }

  Future<dynamic> addAccountLinkage(String idToken) async {
    return await super.create(
      body: {
        "id_token": idToken,
      },
    );
  }

  @override
  dynamic objectTransformer(Map<String, dynamic> json) => json;
}
