import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginGoogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    if (userCredential.user == null) return null;
    await _userCollection.doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': userCredential.user!.email ?? '',
      'avatarURL': userCredential.user!.photoURL,
      'follower': [],
      'following': [],
      'fullname': userCredential.user!.displayName ?? '',
      'idTopTop': '@${createName(userCredential.user!.email)}',
      'ban': false,
      // Thêm các thông tin khác nếu cần
    });

    return userCredential.user;
  }

  String createName(String? email) {
    if (email != null && email.isNotEmpty) {
      int atIndex = email.indexOf('@');
      if (atIndex != -1 && atIndex < email.length - 1) {
        String domain = email.substring(0, atIndex);
        return domain;
      }
    }
    return ""; // Trả về giá trị mặc định nếu không có email hoặc không tìm thấy '@'
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
