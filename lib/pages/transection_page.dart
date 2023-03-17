import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../utils/my_card.dart';

class transactionPage extends StatefulWidget {
  const transactionPage({super.key});

  @override
  State<transactionPage> createState() => _transactionPageState();
}

class _transactionPageState extends State<transactionPage> with ChangeNotifier {
  List<Widget> transaction = [];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    getTransectionInfo();
    notifyListeners();
    super.initState();
  }

  void getTransectionInfo() {
    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.phoneNumber)
        .collection('transactions')
        .orderBy('tNumber', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      print(querySnapshot.docs.length);
      // String ID = querySnapshot.data.docs
      querySnapshot.docs.forEach((doc) {
        String ref = doc['type'];
        String phoneNumber;
        if (ref == 'receive from card') {
          phoneNumber = doc['cardNumber'];
        } else {
          phoneNumber = doc['phoneNumber'];
        }
        print('${doc['amount']}');
        setState(() {
          transaction.add(MyCard(
              amount: doc['amount'].toDouble(),
              phoneNumber: phoneNumber,
              dateTime: doc['time'],
              transactionId: doc.id,
              transactionType: doc['type']));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(entries.length);
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
          'Your transaction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        // children: [
        itemCount: transaction.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: transaction[index],
          );
        },
      ),
    );
  }
}
