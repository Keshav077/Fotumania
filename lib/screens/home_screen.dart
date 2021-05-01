import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/items_provider.dart';
import '../providers/user_provider.dart';
import '../providers/service_provider.dart';

import '../screens/main_drawer.dart';
import '../screens/profile_screen.dart';

import '../widgets/app_bar.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/services_icons.dart';
import '../widgets/services_list.dart';

import '../models/user_info.dart';

class NewHomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  String _selectedItem;

  bool _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false).loadUser();
      Provider.of<ItemProvider>(context, listen: false)
          .fetchItemsFromServer()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
  }

  setSelectedItem(String id) {
    setState(() {
      _selectedItem = id;
    });
  }

  goToProfile(BuildContext context, UserInfo user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => Profile(user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ServiceProvider services = Provider.of<ServiceProvider>(context);
    final mqs = MediaQuery.of(context).size;
    final double iconSize = mqs.height > 1500
        ? 45
        : mqs.height > 800
            ? 35
            : 25;
    return Scaffold(
      drawer: MainDrawer(),
      body: Builder(
        builder: (context) {
          return _isLoading
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomAppBar(
                      // openWishList: openWishList,
                      goToProfile: goToProfile,
                    ),
                    Container(
                      height: mqs.height > 800
                          ? mqs.height * 0.75
                          : mqs.height * 0.73,
                      width: mqs.width,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: Colors.black12,
                            offset: Offset(-2, -2),
                            spreadRadius: 2,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: (mqs.height > 800
                                      ? mqs.height * 0.75
                                      : mqs.height * 0.73) *
                                  0.1,
                              child: ServicesIcons(
                                selectedItem: _selectedItem,
                                setSelectedItem: setSelectedItem,
                                iconSize: iconSize,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              height: (mqs.height > 800
                                      ? mqs.height * 0.75
                                      : mqs.height * 0.73) *
                                  0.9,
                              child: _selectedItem == null
                                  ? aboutUs(context)
                                  : Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                services
                                                    .servicesList[services
                                                        .getServiceIndex(
                                                            _selectedItem)]
                                                    .serviceName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.center,
                                          height: (mqs.height > 800
                                                  ? mqs.height * 0.75
                                                  : mqs.height * 0.73) *
                                              0.2 *
                                              0.6,
                                          width: mqs.width,
                                          child: Text(
                                            services
                                                .servicesList[
                                                    services.getServiceIndex(
                                                        _selectedItem)]
                                                .serviceContent,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        Container(
                                          height: mqs.height > 800
                                              ? mqs.height * 0.75 * 0.63
                                              : mqs.height * 0.73 * 0.6,
                                          child: ServiceList(
                                            serviceId: _selectedItem,
                                            widthRatio: services
                                                .servicesList[
                                                    services.getServiceIndex(
                                                        _selectedItem)]
                                                .widthRatio,
                                          ),
                                        ),
                                        NavigationBar(
                                          user: userProvider.user,
                                          goToProfile: goToProfile,
                                          setSelectedItem: setSelectedItem,
                                          iconSize: iconSize,
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

Widget aboutUs(BuildContext context) {
  double mqs = MediaQuery.of(context).size.height;
  return Container(
    height: (mqs > 800 ? mqs * 0.75 : mqs * 0.73) * 0.9,
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "About Us",
          style: Theme.of(context).textTheme.headline5,
        ),
        Divider(),
        Text(
          "We are Fotumania. We work with your imaginations to find a better match. Our Aim is to give an eye to your details and bring them into life within affordable segments . We offer a wide range of prices to fall into your budgets. We are flexible with Time and places. We give our best to coordinate with your kind of perfection. We are just a click away :)",
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  );
}
