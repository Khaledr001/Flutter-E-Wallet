import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double amount;
  final String phoneNumber;
  final String dateTime;
  final String transactionId;
  late String transactionType;

  MyCard(
      {Key? key,
      required this.amount,
      required this.phoneNumber,
      required this.dateTime,
      required this.transactionId,
      required this.transactionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String txt = 'Phone Number: ';
    if (transactionType == 'receive') {
      transactionType = 'Received from';
    } else if (transactionType == 'send') {
      transactionType = 'Sent to';
    } else {
      transactionType = "Recieved from card";
      txt = 'Card Number: ';
    }
    String datetime = dateTime.substring(0, 19);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 6),
      child: Container(
        height: 110,
        width: MediaQuery.of(context).size.width * 0.80,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Transactions information
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  transactionType,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  txt + phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Trans ID: ' + transactionId,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  datetime,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // Amount details
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${amount}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
