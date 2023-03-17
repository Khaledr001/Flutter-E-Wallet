import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_wallet/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/Credit_card_model.dart';
import 'package:e_wallet/provider/auth_provider.dart';
import 'package:e_wallet/model/user_model.dart';
import 'package:e_wallet/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class MyCardForm extends StatefulWidget {
  const MyCardForm({Key? key}) : super(key: key);

  @override
  State<MyCardForm> createState() => _MyCardFormState();
}

class _MyCardFormState extends State<MyCardForm> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final HomePage hp = new HomePage();
    // var creditCardForm = CreditCardForm;
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
          'Enter your Card\'s Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: ExactAssetImage('assets/bg.jpg'),
          //   fit: BoxFit.fill,
          // ),
          color: Color.fromARGB(255, 241, 239, 239),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                // bankName: 'Axis Bank',
                frontCardBorder: !useGlassMorphism
                    ? Border.all(color: Color.fromARGB(255, 38, 74, 231))
                    : null,
                backCardBorder: !useGlassMorphism
                    ? Border.all(color: Color.fromARGB(255, 56, 98, 238))
                    : null,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: Color.fromARGB(255, 0, 0, 0),
                backgroundImage: useBackgroundImage ? 'assets/bg.jpg' : null,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: CardType.mastercard,
                    cardImage: Image.asset(
                      'assets/mastercard.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        textColor: Color.fromARGB(255, 0, 0, 0),
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            // card information sent to firebase database and home page card.
                            await ap.cardAdd(
                                context: context,
                                cardHolderName: cardHolderName,
                                cardNumber: cardNumber,
                                cvvCode: cvvCode,
                                expiryDate: expiryDate);

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                            // String uid = user.uid!;
                            print('card add');
                          } else {
                            print('invalid!');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 94, 92, 240),
                                Color.fromARGB(255, 103, 70, 223),
                                Color.fromARGB(255, 152, 149, 197),
                                Color.fromARGB(255, 174, 167, 194),
                                Color.fromARGB(255, 152, 149, 197),
                                Color.fromARGB(255, 103, 70, 223),
                                Color.fromARGB(255, 94, 92, 240),
                              ],
                              begin: Alignment(-1, -4),
                              end: Alignment(1, 4),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _onValidate() {
  //   if (formKey.currentState!.validate()) {
  //     // card information sent to firebase database and home page card.

  //     print('valid!');
  //   } else {
  //     print('invalid!');
  //   }
  // }

  void onCreditCardModelChange(creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
