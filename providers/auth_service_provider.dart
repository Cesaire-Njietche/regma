import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/regma_services.dart';
import 'courses_provider.dart';
import 'media_provider.dart';

enum Status { Registered, SignedIn, SignedOut }

class AuthServiceProvider with ChangeNotifier {
  MUser _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isAdmin = false;
  Status status;
  RegmaServices regmaServices = RegmaServices();
  CoursesProvider courses;
  MediaProvider media;
  AuthServiceProvider({this.media, this.courses});
  bool paymentOptions = false;

  User get currentUser {
    return auth.currentUser;
  }

  MUser get user {
    return _user;
  }

  Future<String> login(String email, String password) async {
    try {
      final authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      isAdmin = false;
      if (authResult.user.emailVerified) {
        // var token = await authResult.user.getIdTokenResult(true);
        // if (token.claims['admin'] == true) {
        //   isAdmin = true;
        // }
        await regmaServices.setParentalCode(password);
        paymentOptions = await RegmaServices().getPaymentOptions();
        courses.paymentOptions = paymentOptions;
        media.paymentOptions = paymentOptions;
        //Construct the user
        await constructUser();
        // var parentalCode = await regmaServices.getParentalCode();
        // if (parentalCode.compareTo('***') == 0) {
        //   //For users who were previously registered
        //   await regmaServices.setParentalCode(password);
        // }

        notifyListeners();
        status = Status.SignedIn;
        return "Signed In";
      } else
        return 'Not verified';
    } on FirebaseAuthException catch (err) {
      status = Status.SignedOut;
      return err.message;
    }
  }

  Future<String> register(String email, String password) async {
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      isAdmin = false;
      await auth.currentUser.sendEmailVerification();
      var token = await auth.currentUser.getIdTokenResult(true);
      if (token.claims['admin'] == true) {
        isAdmin = true;
      }
      notifyListeners();
      status = Status.Registered;
      paymentOptions = await RegmaServices().getPaymentOptions();
      courses.paymentOptions = paymentOptions;
      media.paymentOptions = paymentOptions;
      return 'Signed Up';
    } on FirebaseAuthException catch (err) {
      status = Status.SignedOut;
      return err.message;
    }
  }

  Future<void> constructUser() async {
    //Construct the user
    var userData = await regmaServices.getUser(currentUser.uid);
    _user = MUser.fromJson(userData);
    //print(isAdmin);
    var token = await currentUser.getIdTokenResult(true);
    if (token.claims['admin'] == true) {
      isAdmin = true;
    }
    _user.isAdmin = isAdmin;
  }

  Future<void> updateUserProfile(
      Map<String, dynamic> user, File picture) async {
    await regmaServices.saveUser(user, false, picture);
    var id = _user.userID;
    var userData = await regmaServices.getUser(id);
    _user = MUser.fromJson(userData);
    _user.isAdmin = isAdmin;
    notifyListeners();
  }

  Future<void> setIsVisibleOnSearch(bool val) async {
    await regmaServices.setIsVisibleOnSearch(val);
    _user.isVisibleOnSearch = val;
    notifyListeners();
  }

  Future<void> resetPwd(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (err) {
      throw err;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      String email = auth.currentUser.email;
      await auth.currentUser.updatePassword(
          newPassword); //No need to re-authenticate. This will trigger the userChanges listener
      await regmaServices.setParentalCode(newPassword);
      // final credential =
      //     EmailAuthProvider.credential(email: email, password: newPassword);
      // await auth.currentUser.reauthenticateWithCredential(
      //     credential); //Re-authenticate after updating the password
    } catch (err) {
      throw err;
    }
  }

  Future<void> signOut() async {
    status = Status.SignedOut;
    await auth.signOut();
  }
}
