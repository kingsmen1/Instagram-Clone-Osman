import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/state/auth/constants/constants.dart';
import 'package:instagram_clone/state/auth/models/auth_result.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

class Authenticator {
  const Authenticator();
  User? get currentUser => FirebaseAuth.instance.currentUser;
  UserId? get userId => currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayaName => currentUser?.displayName ?? '';
  String? get email => currentUser?.email;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> logingWithFacebook() async {
    final loginResult =
        await FacebookAuth.instance.login(); //returns a LoginResult.
    final token = loginResult.accessToken?.token;
    if (token == null) {
      //user has aborted the logging process.
      return AuthResult.aborted;
    }
    //on successful facebook login we get credentials by passing that token.
    final oauthCredentials = FacebookAuthProvider.credential(token);
    try {
      //^NOTE:even though we logging with facebook it doesn't mean we logged in to firebase.
      //so then we Authenticating to firebase also with fb credentials as our app
      //needs to be authenticated in order to work with Firebase.
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      //^NOTE: If we have Federated Sign in like google & facebook signin &
      //^if we already logged in with google & then we logged out & then trying
      //^to login in with same credentials with Facebook we get Exception because
      //^as we logged in with another oauthCredential that is linked to another
      //^provider which is google & now we logging in with same credentials with
      //^facebook which will be linked to facebook's provider so thats not accepted.
      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredentials &&
          email != null &&
          credential != null) {
        //we checking if last method for loging in by user
        final provider =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        //if the login method was google we log them with google again.
        if (provider.contains(Constants.googleCom)) {
          await loginWithGoogle();
          //*Federated Authentication : It means to allow users to login with same
          //*email using either facebook or google.
          FirebaseAuth.instance.currentUser?.linkWithCredential(
            credential,
          );
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);
    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;

    final AuthCredential oauthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure;
    }
  }
}
