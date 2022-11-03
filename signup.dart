import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fb_auth_emailpass/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  var confirmPassword = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  registration() async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // ignore: avoid_print
        print(userCredential);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registered Successfully. Please Login...",
          style: TextStyle(fontSize: 20.0),
        )));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: avoid_print
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Password Provided is too Weak",
            style: TextStyle(fontSize: 20.0),
          )));
        } else if (e.code == 'email-already-in-use') {
          // ignore: avoid_print
          print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Account Already exists",
            style: TextStyle(fontSize: 20.0),
          )));
        }
      }
    } else {
      // ignore: avoid_print
      print("Password and Confirm Password doesn't match");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Password and Confirm Password doesn't match",
        style: TextStyle(fontSize: 20.0),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" User SignUp"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15)),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Email ";
                    } else if (!value.contains("@")) {
                      return "Please Enter Valid Email";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15)),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Password ";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15)),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Password ";
                    }
                    return null;
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                          confirmPassword = confirmPasswordController.text;
                        });
                        registration();
                      }
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 18.0),
                    )),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an Account?"),
                TextButton(
                    onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const Login()),
                          )
                        },
                    child: const Text("Login")),
              ])
            ]),
          )),
    );
  }
}
