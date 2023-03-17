import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_wallet/utils/transection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/my_textField.dart';
import '../utils/start_custom_button.dart';
import '../utils/utils.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final moneyController = TextEditingController();
  final cardNumberController = TextEditingController();
  final textController = TextEditingController();

  final transectionUtils tu = new transectionUtils();
  final myTextField textField = new myTextField();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // decoration: const BoxDecoration()
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Add', 
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' Money',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: const [
                          Text(
                            'Add Money to your E-Wallet Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Text(
                            'From your Card',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          textField.textFeld(
                            hintText: 'Enter your Card Number',
                            icon: Icons.credit_card_rounded,
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            maxLines: 1,
                            textSize: 18,
                            fontWeight: FontWeight.bold,
                            controller: cardNumberController,
                          ),
                          const SizedBox(height: 10),
                          textField.textFeld(
                            hintText: 'Enter amount',
                            icon: Icons.monetization_on_outlined,
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            maxLines: 1,
                            textSize: 18,
                            fontWeight: FontWeight.bold,
                            controller: moneyController,
                          ),
                          const SizedBox(height: 10),
                          textField.textFeld(
                            hintText: 'Note',
                            icon: Icons.notes,
                            inputType: TextInputType.text,
                            maxLines: 2,
                            textSize: 17,
                            fontWeight: FontWeight.normal,
                            controller: textController,
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 50,
                            child: CustomButton(
                                text: "Validate and Confirm",
                                onPressed: () {
                                  double amount =
                                      double.parse(moneyController.text.trim());
                                  assert(amount is double);
                                  // print(amount);
                                  String cardNumber = cardNumberController.text
                                      .trim() as String;
                                  // print(cardNumber);
                                  String reference =
                                      textController.text.trim() as String;
                                  // print(reference);

                                  String transactionId =
                                      tu.genarateTransactionId();
                                  String time = tu.dateTime();

                                  moneyAdded(
                                      context, cardNumber, amount, reference);
                                  ap.addReceiveTransactionInfoFromCard(
                                      context: context,
                                      transactionType: 'receive from card',
                                      cardNumber: cardNumber,
                                      amount: amount,
                                      reference: reference,
                                      transactionId: transactionId,
                                      time: time);

                                  Navigator.pop(context, true);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moneyAdded(BuildContext context, String cardNumber, double amount,
      String reference) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .get()
          .then((DocumentSnapshot snapshot) async {
        await _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.phoneNumber)
            .update({'balance': snapshot['balance'] + amount});
      });
      print('balance updated');
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }
}
