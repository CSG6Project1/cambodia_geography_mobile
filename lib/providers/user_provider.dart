import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/main.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/services/storages/user_token_storage.dart';

class UserProvider extends ChangeNotifier {
  late UserTokenStorage userTokenStorage;
  late UserTokenModel? _userToken;
  late String? initialRoute;
  late UserApi userApi;
  UserModel? get user => _user;
  UserModel? _user;

  set user(UserModel? user) {
    if (this._user == user) return;
    this._user = user;
    notifyListeners();
  }

  UserProvider(this._userToken) {
    this.userApi = UserApi();
    this.userTokenStorage = UserTokenStorage();
    fetchCurrentUser();
  }

  Future<void> signOut() async {
    await userTokenStorage.remove();
    this._user = null;
    this._userToken = null;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    UserTokenModel? token = await getInitalUserToken();
    if (token != null && token.accessToken != null) {
      _userToken = token;
      _user = await userApi.fetchCurrentUser();
      notifyListeners();
    }
  }

  bool get isSignedIn => this._userToken?.accessToken != null;
}
