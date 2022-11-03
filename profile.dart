import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;
  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Verification Email has been sent",
        style: TextStyle(fontSize: 20.0),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Text(
            "User Id: $uid",
            style: const TextStyle(fontSize: 18.0),
          ),
          Row(
            children: [
              Text(
                "Email: $email",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                width: 10,
              ),
              user!.emailVerified
                  ? const Text('verified', style: TextStyle(fontSize: 18.0))
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: const Text("Verify Email"))
            ],
          ),
          Text(
            "Created: $creationTime",
            style: const TextStyle(fontSize: 18.0),
          )
        ],
      ),
    );
  }
}
