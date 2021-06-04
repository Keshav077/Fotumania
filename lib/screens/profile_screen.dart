import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fotumania/models/photographers.dart';
import 'package:fotumania/models/user_info.dart';
import 'package:fotumania/providers/photographers_provider.dart';
import 'package:fotumania/providers/user_provider.dart';
import 'package:fotumania/widgets/display_user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final UserInfo user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _editable = false, _isInit = false;
  Size mqs;
  TextEditingController name,
      contact,
      email,
      location,
      pricePerHour,
      specialization;
  UserProvider userProvider;
  PhotographersProvider photographersProvider;
  Photographers photographerDetails;
  File _image;
  ImagePicker picker = new ImagePicker();

  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInit) {
      name = TextEditingController(text: widget.user.userName);
      contact = TextEditingController(text: widget.user.contact);
      email = TextEditingController(text: widget.user.email);
      location = TextEditingController(text: widget.user.location);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      photographersProvider =
          Provider.of<PhotographersProvider>(context, listen: false);
      mqs = MediaQuery.of(context).size;
      await userProvider.loadUser();
      // if (widget.user.userType == UserType.ServiceProvider) {
      //   photographerDetails =
      //       photographersProvider.getPhotographerWithId(widget.user.userId);

      //   specialization = TextEditingController(
      //       text: photographerDetails.specialization.join(', '));
      // }
      _isInit = true;
    }
  }

  Future getImage() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 300);
    setState(() {
      _image = File(image.path);
      print(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            )),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Row(children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Container(
                    child: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ]),
                InkWell(
                  onTap: getImage,
                  child: Container(
                    margin: EdgeInsets.all(50),
                    width: mqs.height * 0.2,
                    height: mqs.height * 0.2,
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
                          image: _image != null
                              ? FileImage(_image)
                              : NetworkImage(widget.user.imageUrl == null
                                  ? "https://cdn.pixabay.com/photo/2018/04/18/18/56/user-3331256__340.png"
                                  : widget.user.imageUrl),
                        ),
                        border: Border.all(
                            width: 5, color: Colors.white.withOpacity(.8)),
                        shape: BoxShape.circle),
                  ),
                ),
                DisplayUserInfo(
                  "Name",
                  name,
                  _editable,
                ),
                DisplayUserInfo(
                  "Email",
                  email,
                  false,
                ),
                DisplayUserInfo(
                  "Contact",
                  contact,
                  _editable,
                ),
                DisplayUserInfo(
                  "Location",
                  location,
                  _editable,
                ),
                if (photographerDetails != null)
                  Column(
                    children: [
                      DisplayUserInfo(
                        "Specialization",
                        specialization,
                        _editable,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(
                              () {
                                _editable = !_editable;
                              },
                            );
                          },
                          child: Container(
                            height: mqs.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: Text(
                              "Edit",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await userProvider.editUserDetails(
                              image: _image,
                              location: location.text,
                              name: name.text,
                              contact: contact.text,
                            );
                            // if (photographerDetails != null)
                            //   photographersProvider.editPhotographerDetails(
                            //     id: widget.user.userId,
                            //     pricePerHour: pricePerHour.text,
                            //     specialization: specialization.text,
                            //   );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                            height: mqs.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: Text(
                              "Save",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
