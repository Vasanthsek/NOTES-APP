import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_taking_app/auth/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  //------------------------------------------

  startauthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';
      if (err.message != null) {
        message = err.message.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "DAILY NOTES APP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(30),
                height: 200,
                child: Image.asset('images/planning.png'),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoginPage)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: const ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Incorrect Username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide()),
                              labelText: "Enter Username",
                              labelStyle: GoogleFonts.roboto()),
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Incorrect Email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide()),
                            labelText: "Enter Password",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                height: 70,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        primary:
                                            Theme.of(context).primaryColor),
                                    child: isLoginPage
                                        ? Text('Login',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16))
                                        : Text('SignUp',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16)),
                                    onPressed: () {
                                      startauthentication();
                                    })),
                          ),
                          const Text(
                            "Or",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Expanded(child: GSI()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLoginPage = !isLoginPage;
                              });
                            },
                            child: isLoginPage
                                ? Wrap(children: [
                                    Text('Not a Member?',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.white)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Sign Up",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ])
                                : Wrap(children: [
                                    Text('Already a Member?',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.white)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Login",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ])),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
