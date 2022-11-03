import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fb_auth_emailpass/login.dart';
import 'package:flutter_fb_auth_emailpass/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Password Reset Email has been sent !",
        style: TextStyle(fontSize: 20.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No User Found for that Email",
          style: TextStyle(fontSize: 20.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Reset Password"),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(top: 20.0),
                child: const Text("Reset Link will be sent to your email id !",
                    style: TextStyle(fontSize: 20))),
            Expanded(
                child: Form(
              key: _formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            autofocus: false,
                            decoration: const InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15)),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Email ";
                              } else if (!value.contains("@")) {
                                return "Please Enter Valid Email";
                              }
                              return null;
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 30.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        email = emailController.text;
                                      });
                                      resetPassword();
                                    }
                                  },
                                  child: const Text(
                                    "Send Email",
                                    style: TextStyle(fontSize: 18.0),
                                  )),
                              TextButton(
                                  onPressed: () => {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  const Login()),
                                        )
                                      },
                                  child: const Text("Login")),
                            ]),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an Account?"),
                            TextButton(
                                onPressed: () => {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, a, b) =>
                                                  const SignUp(),
                                              transitionDuration:
                                                  const Duration(seconds: 0)),
                                          (route) => false)
                                    },
                                child: const Text("Signup")),
                          ])
                    ],
                  )),
            ))
          ],
        ));
  }
}
