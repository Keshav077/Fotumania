import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import './screens/order_status.dart';
import './screens/recent_orders.dart';
import './screens/splash_screen.dart';
import './screens/admin_screen.dart';
import './screens/edit_service.dart';
import './screens/photographer_screen.dart';
import './screens/service_classes.dart';
import './screens/service_details_screen.dart';
import './screens/sign_in.dart';
import './screens/home_screen.dart';

import 'package:sizer/sizer.dart';

import './providers/order_provider.dart';
import './providers/photographers_provider.dart';
import './providers/items_provider.dart';
import './providers/user_provider.dart';
import './providers/service_provider.dart';

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
                home: SplashScreen(),
                routes: {
                  NewHomeScreen.routeName: (ctx) => NewHomeScreen(),
                  PhotographersScreen.routeName: (ctx) => PhotographersScreen(),
                  ServiceDetails.routeName: (ctx) => ServiceDetails(),
                  AdminHome.routeName: (ctx) => AdminHome(),
                  EditService.routeName: (ctx) => EditService(),
                  SignIn.routeName: (ctx) => SignIn(),
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
