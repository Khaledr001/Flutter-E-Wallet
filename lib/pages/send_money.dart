import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:e_wallet/utils/transection.dart';
import 'package:e_wallet/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/provider/auth_provider.dart';
import 'package:e_wallet/utils/start_custom_button.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:e_wallet/provider/auth_provider.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final TextEditingController phoneController = TextEditingController();

  final moneyController = TextEditingController();
  final textController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final transectionUtils tu = transectionUtils();

  Country selectedCountry = Country(
    phoneCode: "880",
    countryCode: "BD",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Bangladesh",
    example: "Bangladesh",
    displayName: "Bangladesh",
    displayNameNoCountryCode: "BD",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
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
                            'Send',
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
                            'Send Money to Other E-Wallet Account',
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
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    TextFormField(
                      cursorColor: Colors.purple,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.purple.shade50,
                        filled: true,
                        hintText: "Enter phone number",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 13),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 550,
                                  ),
                                  onSelect: (value) {
                                    setState(() {
                                      selectedCountry = value;
                                    });
                                  });
                            },
                            child: Text(
                              "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        suffixIcon: phoneController.text.length > 9
                            ? Container(
                                height: 30,
                                width: 30,
                                margin: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    textFeld(
                      hintText: 'Enter amount',
                      icon: Icons.monetization_on_outlined,
                      inputType:
                          const TextInputType.numberWithOptions(decimal: true),
                      maxLines: 1,
                      textSize: 18,
                      fontWeight: FontWeight.bold,
                      controller: moneyController,
                    ),
                    const SizedBox(height: 10),
                    textFeld(
                      hintText: 'Reference',
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
                          text: "Send",
                          onPressed: () async {
                            double amount =
                                double.parse(moneyController.text.trim());
                            assert(amount is double);
                            print(amount);
                            String _phoneNumber =
                                phoneController.text.trim() as String;
                            _phoneNumber =
                                "+${selectedCountry.phoneCode}$_phoneNumber";
                            print(_phoneNumber);
                            String reference =
                                textController.text.trim() as String;
                            print(reference);
                            String transactionId = tu.genarateTransactionId();
                            print(transactionId);
                            String datetime = tu.dateTime();

                            moneySend(context, _phoneNumber, reference, amount);
                            ap.addSendTransactionInfo(
                                context: context,
                                transactionType: 'send',
                                PhoneNumber: _phoneNumber,
                                amount: amount,
                                reference: reference,
                                transactionId: transactionId,
                                time: datetime);
                            ap.addReceiveTransactionInfo(
                                context: context,
                                transactionType: 'receive',
                                PhoneNumber: _phoneNumber,
                                amount: amount,
                                reference: reference,
                                transactionId: transactionId,
                                time: datetime);

                            Navigator.pop(context, true);
                          }),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Send money to other account.
  void moneySend(BuildContext context, String _phoneNumber, String reference,
      double amount) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.phoneNumber)
        .get()
        .then((DocumentSnapshot snapshot) async {
      // print(snapshot['balance']);
      if (snapshot['balance'] < amount) {
        showSnackBar(context, 'Insufficient balance');
        // print('Insufficient balance');
        return;
      } else if (await phoneNumberExists(_phoneNumber) == true) {
        try {
          await _firebaseFirestore
              .collection("users")
              .doc(_phoneNumber)
              .get()
              .then((DocumentSnapshot _snapshot) async {
            // _snapshot['balance'] = balance;
            _firebaseFirestore
                .collection('users')
                .doc(_phoneNumber)
                .update({'balance': _snapshot['balance'] + amount});
          });
          _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser!.phoneNumber)
              .update({'balance': snapshot['balance'] - amount});

          print('Successfully updated');
        } on FirebaseException catch (e) {
          showSnackBar(context, e.message.toString());
          // print(e.message.toString());
          return;
        }
      } else {
        showSnackBar(context, 'User not found');
        // print('user not found');
        return;
      }
    });
  }

  Future<bool> phoneNumberExists(String _phoneNumber) async {
    try {
      var collectionRef = _firebaseFirestore.collection('users');
      var doc = await collectionRef.doc(_phoneNumber).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return false;
      // throw e;
    }
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required double textSize,
    required FontWeight fontWeight,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: fontWeight,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 25,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }
}
