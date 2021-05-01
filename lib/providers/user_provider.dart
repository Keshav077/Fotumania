import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fotumania/exception/user_name_exists.dart';
import 'package:http/http.dart' as http;
import '../models/user_info.dart';

class UserProvider with ChangeNotifier {
  UserInfo _currentUser;

  UserInfo get user {
    return UserInfo(
      email: _currentUser.email,
      userName: _currentUser.userName,
      userId: _currentUser.userId,
      location: _currentUser.location,
      contact: _currentUser.contact,
      userType: _currentUser.userType,
      imageUrl: _currentUser.imageUrl,
    );
  }

  Future<void> loadUser() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/users/${user.uid}.json');
      final response = await http.get(url);
      final extracted = json.decode(response.body) as Map<String, dynamic>;
      _currentUser = UserInfo(
        email: extracted['email'],
        contact: extracted['contact'],
        userId: extracted['userId'],
        location: extracted['location'],
        userName: extracted['userName'],
        userType: getUserType(extracted['userType']),
        imageUrl: extracted['profileImageUrl'],
      );
    } catch (error) {
      print(error);
    }
  }

  // UserInfo getUserById(String id) {
  //   return _users[_users.indexWhere((element) => element.userId == id)];
  // }

  Future<void> logout() async {
    _currentUser = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<UserType> loginWithEmailAndPassword(email, password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user.uid;
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/users/$uid.json');
      final response = await http.get(url);
      final extracted = json.decode(response.body) as Map<String, dynamic>;

      _currentUser = UserInfo(
        email: extracted['email'],
        contact: extracted['contact'],
        userId: extracted['userId'],
        location: extracted['location'],
        userName: extracted['userName'],
        userType: getUserType(extracted['userType']),
        imageUrl: extracted['profileImageUrl'],
      );
      print(_currentUser);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFound("User Not Found");
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        throw UserNotFound("Wrong Password");
      }
    } catch (error) {
      // print(error);
      throw UserNotFound("Something went wrong");
    }

    return _currentUser.userType;
  }

  UserType getUserType(String userType) {
    switch (userType) {
      case "UserType.Admin":
        return UserType.Admin;
      case "UserType.Customer":
        return UserType.Customer;
      case "UserType.ServiceProvider":
        return UserType.ServiceProvider;
      default:
        return UserType.NotAUser;
    }
  }

  Future<void> createUser({
    String email,
    String userName,
    String password,
    UserType userType,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/users/${userCredential.user.uid}.json');
      await http.put(
        url,
        body: json.encode(
          {
            'userId': userCredential.user.uid,
            'email': email,
            'userType': userType.toString(),
            'contact': '',
            'location': '',
            'userName': userName,
          },
        ),
      );
    } catch (error) {
      throw UserNameExistsException(
          "You already have an account please login!");
    }
  }

  Future editUserDetails(
      {File image, String name, String location, String contact}) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('profileImages/${_currentUser.userId}');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String profileImageUrl = await taskSnapshot.ref.getDownloadURL();
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/users/${_currentUser.userId}.json');
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'profileImageUrl': profileImageUrl,
            'contact': contact,
            'location': location,
            'userName': name,
          },
        ),
      );
      if (response.statusCode >= 400) throw Exception();
      _currentUser.imageUrl = profileImageUrl;
      _currentUser.userName = name;
      _currentUser.location = location;
      _currentUser.contact = contact;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
