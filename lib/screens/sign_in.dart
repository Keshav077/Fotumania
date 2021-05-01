import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fotumania/exception/user_name_exists.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../models/user_info.dart';

import './admin_screen.dart';
import './photographer_screen.dart';
import './home_screen.dart';

class SignIn extends StatefulWidget {
  final UserType _suserType;
  SignIn(this._suserType);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  bool showSignin = true;

  var _formKey = GlobalKey<FormState>();

  // UserType _suserType;

  final _emailController = TextEditingController(),
      _passwordController = TextEditingController();

  final _sEmailController = TextEditingController(),
      _sPasswordController = TextEditingController(),
      _sConfirmPasswordController = TextEditingController(),
      _sNameController = TextEditingController();

  bool _confirmEmail = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final mqs = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: mqs.width,
            height: mqs.height,
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
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  height: mqs.height * 0.7,
                  width: mqs.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fGNhbWVyYSUyMGluJTIwYmFja2dyb3VuZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.blue[800],
                        BlendMode.softLight,
                      ),
                    ),
                  ),
                  child: Container(
                    height: mqs.height * 0.7,
                    width: mqs.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: mqs.height * 0.07),
                    color: Colors.black54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontFamily: "Tangerine",
                            fontSize: mqs.height * 0.1,
                          ),
                        ),
                        Text(
                          "to Fotumania",
                          style: TextStyle(
                            fontFamily: "Tangerine",
                            fontSize: mqs.height * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                showSignin
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: mqs.height * 0.55,
                            width: mqs.width,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                              height: mqs.height * 0.4,
                              width: mqs.width,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    inputField(
                                      context: context,
                                      controller: _emailController,
                                      validator: (value) =>
                                          value.toString().contains('@')
                                              ? null
                                              : "Invalid Email",
                                      label: "Email",
                                      icon: Icons.person_rounded,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: inputField(
                                            context: context,
                                            controller: _passwordController,
                                            validator: (value) =>
                                                value.length < 6
                                                    ? "Invalid Password"
                                                    : null,
                                            label: "Password",
                                            obs: true,
                                            icon: Icons.stars_sharp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  UserType userType =
                                                      await userProvider
                                                          .loginWithEmailAndPassword(
                                                              _emailController
                                                                  .text,
                                                              _passwordController
                                                                  .text);
                                                  if (!FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      .emailVerified) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please Verify Your Email",
                                                        backgroundColor:
                                                            Colors.blue);
                                                  } else {
                                                    switch (userType) {
                                                      case UserType.Admin:
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                          AdminHome.routeName,
                                                        );
                                                        break;
                                                      case UserType.Customer:
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                          NewHomeScreen
                                                              .routeName,
                                                        );
                                                        break;
                                                      case UserType
                                                          .ServiceProvider:
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                          PhotographersScreen
                                                              .routeName,
                                                        );
                                                        break;
                                                      case UserType.NotAUser:
                                                        break;
                                                    }
                                                  }
                                                } on UserNotFound catch (err) {
                                                  Fluttertoast.showToast(
                                                      msg: err.message,
                                                      backgroundColor:
                                                          Colors.red);
                                                } catch (error) {
                                                  if (this.mounted)
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Something went wrong!",
                                                        backgroundColor:
                                                            Colors.blue);
                                                } finally {
                                                  if (this.mounted)
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                }
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  top: mqs.width * 0.04),
                                              height: mqs.width * 0.125,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child:
                                                  Icon(Icons.arrow_forward_ios),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget._suserType != UserType.Admin)
                                      InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              showSignin = !showSignin;
                                            },
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              vertical: mqs.width * 0.04),
                                          height: mqs.width * 0.12,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            "Sign Up",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                      ),
                                    if (widget._suserType == UserType.Admin)
                                      SizedBox(
                                        height: mqs.width * 0.04,
                                      ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: mqs.height * 0.01,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              thickness: 3,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              "or",
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              thickness: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: mqs.height * 0.02),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: mqs.height * 0.06,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesome.facebook),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Sign in with Facebook"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: mqs.height * 0.06,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesome.google),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Sign in with Google"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              height: mqs.height * 0.55,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mqs.width * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25)),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        inputField(
                                          context: context,
                                          controller: _sEmailController,
                                          validator: (value) =>
                                              value.toString().contains('@')
                                                  ? null
                                                  : "Invalid Email",
                                          label: "Email",
                                          icon: Icons.email,
                                        ),
                                        inputField(
                                          context: context,
                                          controller: _sNameController,
                                          validator: (value) =>
                                              value.toString().length > 3
                                                  ? null
                                                  : "Invalid Username",
                                          label: "Username",
                                          icon: Icons.person_rounded,
                                        ),
                                        inputField(
                                          context: context,
                                          obs: true,
                                          controller: _sPasswordController,
                                          validator: (value) => value.length < 6
                                              ? "Invalid Password"
                                              : null,
                                          label: "Password",
                                          icon: Icons.lock_rounded,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: inputField(
                                                context: context,
                                                obs: true,
                                                controller:
                                                    _sConfirmPasswordController,
                                                validator: (value) => value !=
                                                        _sPasswordController
                                                            .text
                                                    ? "Password doesn't match!"
                                                    : null,
                                                label: "Confirm Password",
                                                icon: Icons.lock_rounded,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: mqs.height * 0.06,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: 25, left: 5),
                                                alignment: Alignment.center,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      try {
                                                        await userProvider
                                                            .createUser(
                                                          email:
                                                              _sEmailController
                                                                  .text,
                                                          userName:
                                                              _sNameController
                                                                  .text,
                                                          password:
                                                              _sPasswordController
                                                                  .text,
                                                          userType:
                                                              widget._suserType,
                                                        );
                                                      } catch (e) {
                                                        // print(e.message);
                                                        //
                                                        Fluttertoast.showToast(
                                                            msg: e.message,
                                                            backgroundColor:
                                                                Colors.red);
                                                        // Toast.show(
                                                        //     e.message, context,
                                                        //     duration: 2);
                                                      }
                                                      setState(() {
                                                        _isLoading = false;
                                                        _sEmailController.text =
                                                            '';
                                                        _sNameController.text =
                                                            '';
                                                        _sPasswordController
                                                            .text = '';
                                                        _sConfirmPasswordController
                                                            .text = '';
                                                      });
                                                      if (FirebaseAuth.instance
                                                                  .currentUser !=
                                                              null &&
                                                          !FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .emailVerified) {
                                                        setState(() {
                                                          _confirmEmail = true;
                                                        });
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            .sendEmailVerification();
                                                        setState(() {
                                                          _confirmEmail = false;
                                                        });
                                                      }
                                                    } else
                                                      Fluttertoast.showToast(
                                                        msg: "Error Signing Up",
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                    // Toast.show(
                                                    //     "Error Signing Up",
                                                    //     context,
                                                    //     backgroundColor:
                                                    //         Colors.red);
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.all(mqs.height * 0.02),
                                          child: InkWell(
                                            child: Text(
                                                "Already Signed Up? Login Here!",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                            onTap: () {
                                              setState(() {
                                                showSignin = true;
                                                _sConfirmPasswordController
                                                    .text = '';
                                                _sPasswordController.text = '';
                                                _sEmailController.text = '';
                                              });
                                            },
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: Container(
                                        //         height: mqs.height * 0.06,
                                        //         decoration: BoxDecoration(
                                        //           color: Theme.of(context)
                                        //               .primaryColor,
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   50),
                                        //         ),
                                        //         child: Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .center,
                                        //           children: [
                                        //             Icon(FontAwesome
                                        //                 .facebook),
                                        //             SizedBox(
                                        //               width: 10,
                                        //             ),
                                        //             Text(
                                        //                 "Sign up with Facebook"),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     Expanded(
                                        //       child: Container(
                                        //         height: mqs.height * 0.06,
                                        //         decoration: BoxDecoration(
                                        //           color: Theme.of(context)
                                        //               .primaryColor,
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   50),
                                        //         ),
                                        //         child: Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .center,
                                        //           children: [
                                        //             Icon(
                                        //                 FontAwesome.google),
                                        //             SizedBox(
                                        //               width: 10,
                                        //             ),
                                        //             Text(
                                        //                 "Sign up with Google"),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            height: mqs.height,
            width: mqs.width,
            color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (_confirmEmail)
          Container(
            height: mqs.height,
            width: mqs.width,
            color: Colors.black26,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Successfully Signed Up",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Icon(
                  Icons.verified,
                  size: 70,
                ),
                Text(
                  "Please Verify Your Email",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Widget inputField(
    {BuildContext context,
    TextEditingController controller,
    Function validator,
    String label,
    bool obs = false,
    IconData icon}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
    child: TextFormField(
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      controller: controller,
      validator: validator,
      obscureText: obs,
      cursorColor: Theme.of(context).primaryColor,
      cursorHeight: 25,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(width: 3, color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(width: 1, color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(width: 3, color: Colors.blue),
        ),
      ),
    ),
  );
}
