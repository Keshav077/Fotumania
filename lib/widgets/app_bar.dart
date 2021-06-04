import 'package:flutter/material.dart';
import 'package:fotumania/models/user_info.dart';
import 'package:fotumania/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final double iconSize = 30;

  final goToProfile;

  CustomAppBar({this.goToProfile});

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    final UserInfo user = Provider.of<UserProvider>(context).user;

    return Container(
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
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: mqs.height * 0.01, horizontal: mqs.width * 0.05),
          child: Column(
            children: [
              Container(
                height: mqs.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        Icons.more_horiz_sharp,
                        size: iconSize,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        "FOTUMANIA",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Provider.of<UserProvider>(context, listen: false)
                            .logout(context);
                      },
                      child: Icon(
                        Icons.logout,
                        size: iconSize,
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                height: mqs.height * 0.13,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => goToProfile(context, user),
                        child: Container(
                          width: mqs.height * 0.12,
                          height: mqs.height * 0.12,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    spreadRadius: 2)
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user.imageUrl == null
                                    ? "https://cdn.pixabay.com/photo/2018/04/18/18/56/user-3331256__340.png"
                                    : user.imageUrl),
                              ),
                              border: Border.all(
                                  width: 5,
                                  color: Colors.white.withOpacity(.8)),
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: mqs.width * 0.05),
                      height: mqs.height * 0.13,
                      width: mqs.width * 0.5,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                              child: Text(
                                "Hello,",
                                style: TextStyle(
                                  fontFamily: "Monstserrat",
                                  // fontSize: mqs.height > 800 ? 24 : 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                              child: Text(user.userName,
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
