import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../utils/start_custom_button.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final moneyController = TextEditingController();
  final cardNumberController = TextEditingController();
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                          textFeld(
                            hintText: 'Enter your Card Number',
                            icon: Icons.credit_card_rounded,
                            inputType:
                                TextInputType.numberWithOptions(decimal: true),
                            maxLines: 1,
                            textSize: 18,
                            fontWeight: FontWeight.bold,
                            controller: cardNumberController,
                          ),
                          const SizedBox(height: 10),
                          textFeld(
                            hintText: 'Enter amount',
                            icon: Icons.monetization_on_outlined,
                            inputType:
                                TextInputType.numberWithOptions(decimal: true),
                            maxLines: 1,
                            textSize: 18,
                            fontWeight: FontWeight.bold,
                            controller: moneyController,
                          ),
                          const SizedBox(height: 10),
                          textFeld(
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
                                text: "Validate and Confirm", onPressed: () {}),
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
