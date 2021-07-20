import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthService {
  socialLoginWithToken({
    required String idToken,
    required String provider,
  }) {
    //TODO: handle with backend
  }

  logInWithGoogle() async {
    String? idToken = await getGoogleIdToken();
    if (idToken == null) return;
    await socialLoginWithToken(idToken: idToken, provider: 'Google');
  }

  loginWithFacebook() async {
    String? idToken = await getFacebookIdToken();
    if (idToken == null) return;
    await socialLoginWithToken(idToken: idToken, provider: 'Facebook');
  }

  Future<String?> getFacebookIdToken() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken? accessToken = result.accessToken;
      if (accessToken?.token == null) return null;
      OAuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);

      try {
        if (FirebaseAuth.instance.currentUser != null) await FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseException catch (e) {
        print(e);
        return null;
      }

      var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      print(idToken);

      if (idToken == null) return null;
      return idToken;
    }
  }

  Future<String?> getGoogleIdToken() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        if (FirebaseAuth.instance.currentUser != null) await FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseException catch (e) {
        print(e);
        return null;
      }

      var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      print(idToken);

      if (await GoogleSignIn().isSignedIn()) await GoogleSignIn().signOut();
      if (idToken == null) return null;
      return idToken;
    }
  }
}
