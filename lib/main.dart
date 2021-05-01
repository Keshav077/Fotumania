import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotumania/models/user_info.dart';
import 'package:fotumania/screens/landing_screen.dart';
import 'package:fotumania/screens/order_status.dart';
import 'package:fotumania/screens/recent_orders.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import './screens/admin_screen.dart';
import './screens/edit_service.dart';
import './screens/photographer_screen.dart';
import './screens/service_classes.dart';
import './screens/service_details_screen.dart';
import './screens/sign_in.dart';

import 'package:sizer/sizer.dart';

import 'package:fotumania/providers/order_provider.dart';
import 'package:fotumania/providers/photographers_provider.dart';

import 'package:fotumania/providers/items_provider.dart';
import 'package:fotumania/providers/user_provider.dart';

import 'package:fotumania/screens/home_screen.dart';

import 'package:fotumania/providers/service_provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: ServiceProvider(),
                ),
                ChangeNotifierProvider.value(
                  value: UserProvider(),
                ),
                ChangeNotifierProvider.value(
                  value: ItemProvider(),
                ),
                ChangeNotifierProvider.value(
                  value: PhotographersProvider(),
                ),
                ChangeNotifierProvider.value(
                  value: OrderProvider(),
                ),
              ],
              child: MaterialApp(
                title: 'Fotumania',
                darkTheme: ThemeData(primaryColor: Colors.grey[900]),
                theme: ThemeData(
                  primaryColor: Colors.blue[400],
                  primaryColorDark: Colors.blue[800],
                  buttonColor: Colors.blue,
                  primaryColorLight: Colors.blue[200],
                  iconTheme: IconThemeData(color: Colors.white),
                  accentColor: Colors.grey,
                  fontFamily: "Quicksand",
                  textTheme: TextTheme(
                    headline1: TextStyle(),
                    headline2: TextStyle(
                      fontFamily: "BebasNeue",
                      color: Colors.white,
                    ),
                    headline3: TextStyle(),
                    headline4: TextStyle(color: Colors.white),
                    headline5: TextStyle(),
                    headline6: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle1: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle2: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    caption: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    bodyText2: TextStyle(
                      color: Colors.white,
                    ),
                    button: TextStyle(
                      color: Colors.white,
                    ),
                    overline: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                home: AnimatedSplashScreen(
                  backgroundColor: Colors.blue,
                  splashIconSize: constraints.maxHeight * 0.25,
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
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, userSnapshot) {
                        if (userSnapshot.hasData &&
                            FirebaseAuth.instance.currentUser.emailVerified) {
                          return NewHomeScreen();
                        }
                        return SignIn(UserType.Customer);
                      }),
                  animationDuration: Duration(milliseconds: 1500),
                  curve: Curves.decelerate,
                  splashTransition: SplashTransition.sizeTransition,
                  pageTransitionType: PageTransitionType.leftToRightWithFade,
                ),
                routes: {
                  NewHomeScreen.routeName: (ctx) => NewHomeScreen(),
                  PhotographersScreen.routeName: (ctx) => PhotographersScreen(),
                  ServiceDetails.routeName: (ctx) => ServiceDetails(),
                  AdminHome.routeName: (ctx) => AdminHome(),
                  EditService.routeName: (ctx) => EditService(),
                  ServiceClassesScreen.routeName: (ctx) =>
                      ServiceClassesScreen(),
                  OrderStatusScreen.routeName: (ctx) => OrderStatusScreen(),
                  RecentOrdersScreen.routeName: (ctx) => RecentOrdersScreen(),
                },
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}
