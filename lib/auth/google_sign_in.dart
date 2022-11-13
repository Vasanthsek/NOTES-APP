import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_taking_app/screens/home.dart';

class GSI extends StatefulWidget {
  const GSI({Key? key}) : super(key: key);

  @override
  State<GSI> createState() => _GSIState();
}

class _GSIState extends State<GSI> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': authResult.user!.displayName,
            'email': authResult.user!.email
          });
        } on FirebaseAuthException catch (e) {
          print("${e.message}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Theme.of(context).primaryColor),
          onPressed: () {
            _googleSignIn();
          },
          child: Text(
            'Google+',
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
          )),
    );
  }
}
