import 'package:flutter/material.dart';
import 'package:fotumania/models/user_info.dart';

class NavigationBar extends StatelessWidget {
  final double iconSize;
  final UserInfo user;
  final Function setSelectedItem, goToProfile;

  NavigationBar(
      {this.user, this.goToProfile, this.setSelectedItem, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    return Container(
      height: mqs.height * 0.75 * 0.07,
      margin: EdgeInsets.only(
          top: mqs.height > 1000
              ? 12
              : mqs.height > 800
                  ? 5
                  : 10,
          left: 15,
          right: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.search,
            size: iconSize,
            color: Theme.of(context).iconTheme.color,
          ),
          InkWell(
            onTap: () {
              setSelectedItem(null);
            },
            child: Icon(
              Icons.home_outlined,
              size: iconSize,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          InkWell(
            onTap: () => goToProfile(context, user),
            child: Icon(
              Icons.person_outline_rounded,
              size: iconSize,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
    );
  }
}
