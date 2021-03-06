import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthService {
  Future<String?> getFacebookIdToken() async {
    final LoginResult result = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);
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
      var uid = FirebaseAuth.instance.currentUser?.uid;
      print(uid);
      print(idToken);

      if (await GoogleSignIn().isSignedIn()) await GoogleSignIn().signOut();
      if (idToken == null) return null;
      return idToken;
    }
  }
}
