import 'package:flutter/material.dart';
import 'package:fotumania/models/user_info.dart';
import 'package:fotumania/screens/sign_in.dart';

class LandingScreen extends StatelessWidget {
  Widget buildButton(
      {Function onPressed,
      String label,
      Size mqs,
      BuildContext context,
      AssetImage image}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(bottom: 5),
            width: mqs.height * 0.2,
            height: mqs.height * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  void nextPage(UserType selectedUser, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    Size mqs = MediaQuery.of(context).size;
    LinearGradient decor = LinearGradient(
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColorDark
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
    return Container(
      decoration: BoxDecoration(gradient: decor),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: decor),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton(
                  label: "Customer",
                  mqs: mqs,
                  context: context,
                  image: AssetImage('assets/images/customer.jpg'),
                  onPressed: () => nextPage(UserType.Customer, context),
                ),
                buildButton(
                  label: "Service Provider",
                  mqs: mqs,
                  context: context,
                  image: AssetImage('assets/images/photographer.jpg'),
                  onPressed: () => nextPage(UserType.ServiceProvider, context),
                ),
                buildButton(
                  label: "Admin",
                  mqs: mqs,
                  context: context,
                  image: AssetImage('assets/images/Admin.jpg'),
                  onPressed: () => nextPage(UserType.Admin, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
