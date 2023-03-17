import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/model/user_model.dart';
import 'package:e_wallet/screens/otp_screen.dart';
import 'package:e_wallet/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber!;
  double? _balance;
  double get balance => _balance!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _phoneNumber = user.phoneNumber;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_phoneNumber).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    // required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      // userModel.balance = _firebaseAuth.currentUser!.balance!;
      // uploading image to firebase storage.
      // await storeFileToStorage("profilePic/$_phoneNumber", profilePic)
      //     .then((value) {
      //   // userModel.profilePic = value;

      // }
      // );
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_phoneNumber)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.phoneNumber)
        .get()
        .then((DocumentSnapshot snapshot) {
      print(snapshot['balance']);
      _userModel = UserModel(
        balance: snapshot['balance'],
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        // profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
      );
      _phoneNumber = userModel.phoneNumber;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _phoneNumber = _userModel!.phoneNumber;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  // Card Add to firesotore database

  Future cardAdd({
    required BuildContext context,
    required String cardHolderName,
    required String cardNumber,
    required String cvvCode,
    required String expiryDate,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('cards')
          .doc(cardNumber)
          .set({
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'cvvCode': cvvCode,
        'expiryDate': expiryDate,
      }).then((value) {
        // onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add the Transactional information to the Firebase

  Future addSendTransactionInfo({
    required BuildContext context,
    required String transactionType,
    required String PhoneNumber,
    required double amount,
    required String reference,
    required String transactionId,
    required String time,
  }) async {
    notifyListeners();
    try {
      int tNumber = 1;
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('transactions')
          // .orderBy('dateTime', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        tNumber = querySnapshot.docs.length + 1;
        transactionId += '_${tNumber}';
      });
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('transactions')
          .doc(transactionId)
          .set({
        'tNumber': tNumber,
        'type': transactionType,
        'phoneNumber': PhoneNumber,
        'amount': amount,
        'reference': reference,
        'time': time,
      }).then((value) {
        // onSuccess();
        // _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      notifyListeners();
    }
  }

  Future addReceiveTransactionInfo({
    required BuildContext context,
    required String transactionType,
    required String PhoneNumber,
    required double amount,
    required String reference,
    required String transactionId,
    required String time,
  }) async {
    notifyListeners();
    try {
      int tNumber = 1;
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('transactions')
          // .orderBy('dateTime', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        tNumber = querySnapshot.docs.length + 1;
        transactionId += '_${tNumber}';
      });
      await _firebaseFirestore
          .collection('users')
          .doc(PhoneNumber)
          .collection('transactions')
          .doc(transactionId)
          .set({
        'tNumber': tNumber,
        'type': transactionType,
        'phoneNumber': _firebaseAuth.currentUser!.phoneNumber,
        'amount': amount,
        'reference': reference,
        'time': time,
      }).then((value) {
        // onSuccess();
        // _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      notifyListeners();
    }
  }

  //
  Future addReceiveTransactionInfoFromCard({
    required BuildContext context,
    required String transactionType,
    required String cardNumber,
    required double amount,
    required String reference,
    required String transactionId,
    required String time,
  }) async {
    notifyListeners();
    try {
      int tNumber = 1;
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('transactions')
          // .orderBy('dateTime', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        tNumber = querySnapshot.docs.length + 1;
        transactionId += '_${tNumber}';
      });

      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.phoneNumber)
          .collection('transactions')
          .doc(transactionId)
          .set({
        'tNumber': tNumber,
        'type': transactionType,
        'cardNumber': cardNumber,
        'amount': amount,
        'reference': reference,
        'time': time,
      }).then((value) {
        // onSuccess();
        // _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      notifyListeners();
    }
  }
}
