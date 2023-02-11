import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double balance;
  final String cardNumber;
  final String expiryMonth;
  final int expiryYear;
  final color;

  const MyCard(
      {Key? key,
      required this.balance,
      required this.cardNumber,
      required this.expiryMonth,
      required this.expiryYear,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 15),
          Text(
            "Balance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$' + balance.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardNumber.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                expiryMonth.toString() + '/' + expiryYear.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
