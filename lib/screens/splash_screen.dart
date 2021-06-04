import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fotumania/screens/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:fotumania/screens/admin_screen.dart';
import 'package:fotumania/screens/home_screen.dart';
import 'package:fotumania/screens/photographer_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size mqs = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
      backgroundColor: Colors.blue,
      splashIconSize: mqs.height * 0.25,
      splash: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              offset: Offset(-4, 4),
              spreadRadius: 7,
            ),
            BoxShadow(
              blurRadius: 5,
              color: Colors.white30,
              offset: Offset(4, -4),
              spreadRadius: 5,
            ),
          ],
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("assets/images/Logo.png"),
          ),
        ),
      ),
      nextScreen: StreamBuilder(
          stream:
              FirebaseAuth.instance.authStateChanges().asyncMap((event) async {
            Uri url = Uri.parse(
                'https://fotumania-33638-default-rtdb.firebaseio.com/users/${event.uid}/userType.json');
            final response = await http.get(url);
            print(json.decode(response.body));
            return json.decode(response.body);
          }),
          // .asyncMap((event) => loadUser(up)),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            if (snap.hasData) {
              if (snap.data == 'UserType.Customer')
                return NewHomeScreen();
              else if (snap.data == 'UserType.Admin')
                return AdminHome();
              else
                return PhotographersScreen();
            } else {
              return SignIn();
            }
          }),
      animationDuration: Duration(milliseconds: 1500),
      curve: Curves.decelerate,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
    );
  }

  // Future<UserType> loadUser(UserProvider up) async {
  //   print("in loader");
  //   await up.loadUser();
  //   print(up.user.userType);
  //   return up.user.userType;
  // }
}

//   Future<Widget> loadScreen(BuildContext ctx) async {
//     final userProvider = Provider.of<UserProvider>(ctx);
//     await userProvider.loadUser();
//     StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (ctx, snap) {
//         if (userProvider.user.userType == UserType.Admin)
//           return AdminHome();
//         else if (userProvider.user.userType == UserType.Customer)
//           return NewHomeScreen();
//         else
//       },
//     );
//   }
// }

// final photographersProvider =
//     Provider.of<PhotographersProvider>(ctx, listen: false);
// photographersProvider.fetchAllPhotographers().then((_) {
// if (!photographersProvider
//     .getPhotographerWithId(userProvider.user.userId)
//     .isVerified)
//   return Scaffold(
//     body: Container(
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "You are not a verified Photographer",
//             style: Theme.of(context)
//                 .textTheme
//                 .headline5,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               userProvider.logout(context);
//             },
//             child: Text("Logout"),
//           ),
//         ],
//       ),
//     ),
//   );
