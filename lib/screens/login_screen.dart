import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getmega_assignment/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  bool isLoading = false;
  late String verificationID;

  Future<void> verifyPhone() async {
    setState(() {
      isLoading = true;
    });
    final PhoneVerificationCompleted verified = (AuthCredential authCredential){
      FirebaseAuth.instance.signInWithCredential(authCredential);
    };
    final PhoneVerificationFailed phoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
    };
    final PhoneCodeSent smsSent = (String verID, [int? forceResend]) {
      verificationID = verID;
      setState(() {
        isOtpSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
      verificationID = verID;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNoController.text}',
      timeout: const Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: phoneVerificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneNoController,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                labelText: 'Phone No',
                hintText: 'Enter 10 digit phone no',
                // errorText: emailError,
                fillColor: Colors.black,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              keyboardType: TextInputType.number,
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            isOtpSent ? TextFormField(
              controller: otpController,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                labelText: 'OTP',
                hintText: 'Enter 6 digit OTP',
                // errorText: emailError,
                fillColor: Colors.black,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              keyboardType: TextInputType.number,
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ) : Container(),
            isOtpSent ? SizedBox(
              height: 10.0,
            ) : Container(),
            ElevatedButton(
                onPressed: () async {
                  if (isOtpSent) {
                    AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);
                    await FirebaseAuth.instance.signInWithCredential(authCredential);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false,);
                  } else {
                    verifyPhone();
                  }
                },
                child: isLoading ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ) : Text(
                  isOtpSent ? 'VERIFY' : 'GET OTP',
                ),
            ),
          ],
        ),
      ),
    );
  }
}
