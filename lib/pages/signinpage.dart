import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subscript/main.dart';
import 'package:subscript/pages/homepage.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  Future<void> signInWithGoogle({required NavigatorState navigator}) async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final firebaseCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (firebaseCredential.user == null) return;

    uid = firebaseCredential.user!.uid;
    navigator.push(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  shadowColor: Colors.grey,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      "icon/logo.png",
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Subscript",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Easy subscription management ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await signInWithGoogle(navigator: navigator);
                  },
                  label: const Text("Sign in with Google"),
                  icon: Image.asset(
                    "icon/search.png",
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
