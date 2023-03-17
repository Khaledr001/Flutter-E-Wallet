// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_wallet/pages/send_money.dart';
import 'package:e_wallet/pages/transection_page.dart';
import 'package:e_wallet/utils/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/auth_provider.dart';
import '../utils/my_card.dart';
import 'package:e_wallet/utils/my_card.dart';
import 'package:e_wallet/utils/my_list_tile.dart';
import 'package:e_wallet/utils/credit_card/my_card_form.dart';

import 'Profile_Page.dart';
import 'add_money.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ChangeNotifier {
  // page Comttoller
  final _controller = PageController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // get card => null;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  List<Widget> myCard = [];
  List<Color> myColor = [
    Colors.purple,
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
  ];
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    getCard();
    notifyListeners();
    super.initState();
  }

  getCard() {
    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.phoneNumber)
        .collection('cards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          myCard.add(
            CreditCardWidget(
              cardNumber: doc["cardNumber"],
              expiryDate: doc['expiryDate'],
              cardHolderName: doc["cardHolderName"],
              cvvCode: doc["cvvCode"],
              showBackView: false,
              obscureCardNumber: false,
              obscureCardCvv: false,
              isHolderNameVisible: true,
              cardBgColor: myColor[(i++) % 4],
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
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomAppBar(
        height: 55,
        // color: Colors.grey[300],
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.home_rounded),
            iconSize: 35,
          ),
          IconButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(Icons.settings),
            iconSize: 35,
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyCardForm()));
        },
        backgroundColor: Colors.pink,
        child: Icon(
          Icons.add_card_rounded,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // appbar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' Cards',
                          style: TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                    //  Plus Icon
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.purple[400],
                          shape: BoxShape.circle,

                          // borderRadius: BorderRadius.circular(50)
                        ),
                        child: Icon(Icons.account_circle_outlined,
                            size: 35, color: Colors.white),
                      ),
                      // radius: 50,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),

              //cards
              Container(
                height: 240,
                // color: Colors.blue,
                child: myCard.length > 0
                    ? PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _controller,
                        children: myCard.map((card) {
                          return card;
                        }).toList(),
                      )
                    : Center(
                        child: Text(
                          'Please Add a Card \n    to your wallet',
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              //button
              SizedBox(height: 2),
              SmoothPageIndicator(
                controller: _controller,
                count: (myCard.length),
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMoney()));
                      },
                      child: MyButton(
                          iconImagePath: 'assets/send-money.png',
                          buttonText: 'Send'),
                    ), // send button
                    // pay buuton
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMoney()));
                      },
                      child: MyButton(
                          iconImagePath: 'assets/add_money.png',
                          buttonText: '  Add\nMoney'),
                    ),
                    // // bills button
                    InkWell(
                      onTap: () {},
                      child: MyButton(
                          iconImagePath: 'assets/bill.png',
                          buttonText: 'Bills'),
                    ),
                  ],
                ),
              ),
              //column -> stats -> trangtion
              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    //statictics
                    InkWell(
                      onTap: () {},
                      child: MyListTitle(
                          iconImagePath: 'assets/statistics.png',
                          titleTitle: 'Statistics',
                          titleSubtitle: 'Payment and Income'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => transactionPage()));
                      },
                      child: MyListTitle(
                          iconImagePath: 'assets/transaction.png',
                          titleTitle: 'Transaction',
                          titleSubtitle: 'Transection History'),
                    ),
                  ],
                ),
              ),

              // bottom nebbar
            ],
          ),
        ),
      ),
    );
  }
}
