import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_wallet/provider/auth_provider.dart';
import 'package:e_wallet/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/start_custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  double balance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.phoneNumber)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        balance = snapshot['balance'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    // print();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[400],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          // weight: MediaQuery.of(context).size.width * 0.80,
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                const CircleAvatar(
                  backgroundColor: Colors.purple,
                  backgroundImage: AssetImage('assets/avatar.png'),
                  radius: 50,
                ),
                const SizedBox(width: 30),
                Text(
                  'Balance: $balance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 45),
            Row(
              children: [
                const SizedBox(width: 40),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ' + ap.userModel.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mobile Number: ' + ap.userModel.phoneNumber,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Email: ' + ap.userModel.email,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'About yourself : \n' + ap.userModel.bio,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 130),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              height: 50,
              child: CustomButton(
                text: "Sign Out",
                onPressed: () async {
                  ap.userSignOut().then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                      (route) => false));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
