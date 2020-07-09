import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId;
String name;
String email;
String imageUrl;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  userId = user.uid.toString();
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  name = user.displayName;
  preferences.setString('by', name);
  email = user.email;
  preferences.setString('email', email);
  imageUrl = user.photoUrl;
  preferences.setString('userPhoto', imageUrl);
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  print("User Sign Out");
}
