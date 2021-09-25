import 'package:firebase_auth/firebase_auth.dart';
import 'package:getmega_assignment/screens/home_screen.dart';
import 'package:getmega_assignment/screens/login_screen.dart';

class AuthHandler {
  handleAuth() {
    if (FirebaseAuth.instance.currentUser == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
