import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String?> signUp(String email,String password)async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
        email:email,
        password:password
        );
        //return userCredential.user;
        return null;
    } on FirebaseAuthException catch(e){
      print("Sign Up Error : $e");
      return e.message;
    }
  }
  Future<String?> signIn(String email,String password)async{
    try{
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(
        email:email,
        password:password
        );
        //return userCredential.user;
        return null;
    }on FirebaseAuthException catch(e){
      print("Sign In Error : $e");
      return e.message;
    }
  }
  
  Future<void> signOut() async{
    await _auth.signOut();
  }
}
