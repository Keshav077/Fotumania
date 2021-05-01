import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'package:fotumania/providers/order_provider.dart';
import 'package:fotumania/providers/user_provider.dart';

import 'package:fotumania/models/item_data.dart';

class ServiceDetails extends StatefulWidget {
  static String routeName = '/service-details';

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  TwilioFlutter twilioFlutter;
  double iconSize = 30;
  String date = "Date", time = "Time", location;
  bool validation = true, _isloading = false;

  File _image;
  ImagePicker picker = new ImagePicker();
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC14406d73c6b41df137b606becb438fa8',
        authToken: '350c6c7d7ee0456e3bcd12aac78ab545',
        twilioNumber: '+16467604551');

    super.initState();
  }

  void sendSms(String number, String message) async {
    twilioFlutter.sendSMS(toNumber: number, messageBody: message);
  }

  Future getImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      print(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final x = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final ItemData item = x['itemData'];
    final Map<String, dynamic> serviceClass = x['classInfo'];
    Size mqs = MediaQuery.of(context).size;
    LinearGradient gradient = LinearGradient(
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColorDark
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Scaffold(
            body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: _isloading
              ? Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: mqs.height * 0.4,
                      width: mqs.width,
                      margin: EdgeInsets.all(10),
                      child: CarouselSlider(
                        items: [
                          ...serviceClass['carouselImages'].split(',').map(
                                (e) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(e),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                        ],
                        options: CarouselOptions(
                          aspectRatio: 9 / 16,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          pageSnapping: true,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: mqs.width,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            spreadRadius: 3,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FittedBox(
                              child: Text(
                                item.name,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              item.content,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  if (item.needDate)
                                    buildDateTimePicker(
                                      TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      context,
                                      Theme.of(context).primaryColorLight,
                                      Theme.of(context).primaryColor,
                                    ),
                                  if (item.needImage)
                                    buildImagePicker(mqs, context),
                                  if (item.needLocation)
                                    buildLocationPicker(context, mqs),
                                  if (item.needLocation) Divider(),
                                  ...buildOrderInfo(serviceClass),
                                  Divider(),
                                  if (!validation)
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text("Invalid Data.",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .fontSize)),
                                    ),
                                  InkWell(
                                    onTap: () async {
                                      if ((item.needDate &&
                                              (date == "Date" ||
                                                  time == "Time")) ||
                                          (item.needImage && _image == null) ||
                                          (item.needLocation &&
                                              location == null)) {
                                        setState(() {
                                          validation = false;
                                        });
                                      } else {
                                        setState(() {
                                          validation = true;
                                        });
                                        Map<String, dynamic> orderDetails = {};
                                        orderDetails['service'] = item.name;
                                        serviceClass.forEach((key, value) {
                                          if (key != "carouselImages") {
                                            orderDetails[key] = value;
                                          }
                                        });
                                        if (item.needDate) {
                                          orderDetails['date'] = date;
                                          orderDetails['time'] = time;
                                        }
                                        if (item.needImage) {
                                          orderDetails['image'] = _image;
                                        }
                                        if (item.needLocation) {
                                          orderDetails['location'] = location;
                                        }
                                        final response = await showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              title: Text("Confirm Order"),
                                              content: Text(
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .orderDetailsToString(
                                                        orderDetails),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(true);
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx)
                                                        .pop(false);
                                                  },
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (response == true) {
                                          try {
                                            setState(() {
                                              _isloading = true;
                                            });
                                            orderDetails[
                                                "orderId"] = await Provider.of<
                                                        OrderProvider>(context,
                                                    listen: false)
                                                .createOrder(
                                                    orderDetails,
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .userId);
                                            Toast.show(
                                              "Booking Successful",
                                              context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM,
                                              backgroundColor: Colors.green,
                                              backgroundRadius: 5,
                                            );
                                            // sendSms(
                                            //   "+918522822026",
                                            //   "Booking Successful\nBooking Details\n" +
                                            //       Provider.of<OrderProvider>(
                                            //               context,
                                            //               listen: false)
                                            //           .orderDetailsToString(
                                            //               orderDetails) +
                                            //       "\nThank you for choosing Fotumania\n- Team Fotumania",
                                            // );
                                          } catch (error) {
                                            Toast.show(
                                              "Booking Failed",
                                              context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM,
                                              backgroundColor: Colors.red,
                                              backgroundRadius: 5,
                                            );
                                          }
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                                    splashColor: Colors.white,
                                    child: Container(
                                      height: mqs.height * 0.08,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: FittedBox(
                                        child: Text(
                                          "Book Now",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          textScaleFactor: 1.5,
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
                    ))
                  ],
                ),
        )),
      ),
    );
  }

  Future getLocation() async {
    LocationData locData = await Location().getLocation();

    return locData.latitude.toString() + " " + locData.longitude.toString();
  }

  InkWell buildLocationPicker(BuildContext context, Size mqs) {
    BorderRadius borderRadius = BorderRadius.circular(10);
    Row divider = Row(
      children: [
        Expanded(child: Divider()),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            "or",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black38,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
    return InkWell(
      onTap: () => showModalBottomSheet(
          backgroundColor: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          context: context,
          builder: (ctx) {
            return Container(
              height: mqs.height * 0.35,
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    onSubmitted: (value) {
                      Navigator.of(context).pop(value);
                    },
                    cursorColor: Colors.white,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  divider,
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop(getLocation());
                    },
                    child: Container(
                      height: mqs.height * 0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: borderRadius),
                      alignment: Alignment.center,
                      child: Text(
                        "Get current location",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  divider,
                  Container(
                    height: mqs.height * 0.06,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: borderRadius,
                    ),
                    child: Text(
                      "Let Fotumania Decide",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                ],
              ),
            );
          }).then((value) {
        setState(() {
          location = value;
          print(location);
        });
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        height: mqs.height * 0.05,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          location == null ? "Location" : location,
          style: Theme.of(context).textTheme.headline6,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Container buildImagePicker(Size mqs, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: getImage,
              child: Container(
                alignment: Alignment.center,
                height: mqs.height * 0.05,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _image == null ? "Image" : _image.path,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: _image == null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    height: mqs.height * 0.05,
                    width: mqs.width * 0.1,
                    child: Icon(Icons.more_horiz))
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    height: mqs.height * 0.05,
                    width: mqs.width * 0.1,
                  ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List<Widget> buildOrderInfo(Map<String, dynamic> serviceClass) {
    List<Widget> result = [];
    final textStyle = TextStyle(fontSize: 18, color: Colors.black);
    serviceClass.forEach(
      (key, value) {
        if (key != "carouselImages") {
          result.add(
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    key[0].toUpperCase() + key.substring(1),
                    style: textStyle,
                  ),
                  Text(
                    value,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
    return result;
  }

  Widget buildDateTimePicker(TextStyle textStyle, BuildContext context,
      Color borderColor, Color bgColor) {
    final mqs = MediaQuery.of(context).size;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Nov',
      'Dec',
    ];
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: bgColor,
    );
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              child: Container(
                decoration: decoration,
                alignment: Alignment.center,
                height: mqs.height * 0.05,
                child: Text(
                  date,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              onTap: () => showDatePicker(
                context: context,
                initialDate: DateTime.now().add(
                  Duration(days: 1),
                ),
                firstDate: DateTime.now().add(
                  Duration(days: 1),
                ),
                lastDate: DateTime.now().add(
                  Duration(days: 365 * 10),
                ),
              ).then(
                (value) {
                  if (value != null) {
                    setState(
                      () {
                        date = value.day.toString() +
                            " " +
                            months[value.month - 1] +
                            " " +
                            value.year.toString();
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () => showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                if (value != null)
                  setState(() {
                    time = value.format(context);
                  });
              }),
              child: Container(
                alignment: Alignment.center,
                decoration: decoration,
                height: mqs.height * 0.05,
                child: Text(
                  time,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}

// previous build

// Column buildOrderDetails(BuildContext context,
//     Map<String, String> serviceClass, ItemData itemData) {
//   TextStyle textStyle = TextStyle(
//       color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);
//   final EdgeInsets margin = EdgeInsets.symmetric(vertical: 7, horizontal: 5);
//   return Column(
//     children: [
//       if (itemData.serviceId == "003")
//         Container(
//           height: 100,
//           child: GridView(
//             scrollDirection: Axis.horizontal,
//             gridDelegate:
//                 SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//             children: [
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1"),
//               Text("1")
//             ],
//           ),
//         )
//       else if (["004", "005"].contains(itemData.serviceId))
//         Column(
//           children: [
//             Text("Availble Options"),
//             Row(
//               children: [
//                 Chip(
//                   label: Text("1"),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Chip(
//                   label: Text("2"),
//                 ),
//               ],
//             )
//           ],
//         )
//       else
//         Column(
//           children: [
//             Container(
//               margin: margin,
//               child: buildDatePicker(textStyle, context),
//             ),
//             Container(
//               margin: margin,
//               child: buildTimePicker(textStyle, context),
//             ),
//           ],
//         ),
//       ...serviceClass.keys.toList().map(
//             (e) => Container(
//               margin: margin,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     e,
//                     style: textStyle,
//                   ),
//                   Text(
//                     serviceClass[e],
//                     style: textStyle,
//                   )
//                 ],
//               ),
//             ),
//           ),
//     ],
//   );
// }

// final mediaQuery = MediaQuery.of(context);
// final screenSize = mediaQuery.size.height;
// return SafeArea(
//   top: true,
//   child: Scaffold(
//     body: Stack(
//       alignment: Alignment.topCenter,
//       children: [
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 500),
//           child: Container(
//             key: ValueKey<String>(item
//                 .carouselImages[currentImage % item.carouselImages.length]),
//             height: screenSize,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(item.carouselImages[
//                     currentImage % item.carouselImages.length]),
//               ),
//             ),
//           ),
//         ),
//         BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 10,
//             sigmaY: 10,
//           ),
//           child: Container(
//             color: Colors.black.withOpacity(0.1),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: mediaQuery.size.height * 0.03),
//           child: FractionallySizedBox(
//             heightFactor: 0.4,
//             child: PageView.builder(
//               onPageChanged: (value) {
//                 setState(() {
//                   currentImage = value;
//                 });
//               },
//               itemBuilder: (ctx, index) {
//                 return FractionallySizedBox(
//                   widthFactor: 0.8,
//                   child: Container(
//                     margin: EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black54,
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(5, 5),
//                         )
//                       ],
//                       borderRadius: BorderRadius.circular(20),
//                       image: DecorationImage(
//                           image: NetworkImage(item.carouselImages[
//                               index % item.carouselImages.length]),
//                           fit: BoxFit.cover),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.bottomCenter,
//           // margin: EdgeInsets.only(bottom: screenSize * 0.3),
//           child: Container(
//             height: screenSize * 0.55,
//             width: mediaQuery.size.width,
//             decoration: BoxDecoration(
//                 color: Colors.white70,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25),
//                     topRight: Radius.circular(25))),
//             padding: EdgeInsets.all(20),
//             margin: EdgeInsets.symmetric(horizontal: 10),
//             child: ListView(
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(5),
//                   child: Text(
//                     item.name,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 30, color: Colors.black54),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   alignment: Alignment.center,
//                   // height: screenSize > 800
//                   //     ? screenSize * 0.14
//                   //     : screenSize * 0.11,
//                   child: Text(
//                     item.content,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 buildOrderDetails(context, serviceClass, item),
//                 Divider(),
//                 InkWell(
//                   onTap: () {
//                     if (date == "Pick Date" || time == "Pick Time") {
//                       setState(() {
//                         validation = false;
//                       });
//                     } else {
//                       setState(() {
//                         validation = true;
//                       });
//                       Map<String, dynamic> orderDetails = {
//                         "date": date,
//                         "time": time,
//                         "session": serviceClass['session'],
//                         "price": serviceClass['price'],
//                         "crew": serviceClass['crew'],
//                         "class": serviceClass['class'],
//                         "service": item.name,
//                         "serviceItemId": item.itemId,
//                       };
//                       Provider.of<OrderProvider>(context, listen: false)
//                           .createOrder(
//                               orderDetails,
//                               Provider.of<UserProvider>(context,
//                                       listen: false)
//                                   .user
//                                   .userId);
//                       Toast.show(
//                         "Booking Successful",
//                         context,
//                         duration: Toast.LENGTH_SHORT,
//                         gravity: Toast.BOTTOM,
//                         backgroundColor: Colors.green,
//                         backgroundRadius: 5,
//                       );
//                     }
//                   },
//                   splashColor: Colors.white,
//                   child: Container(
//                     height: screenSize * (screenSize > 800 ? 0.08 : 0.06),
//                     width: double.infinity,
//                     margin: EdgeInsets.all(10),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Colors.blue[700],
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text(
//                       "Book Now",
//                       style: TextStyle(
//                           fontFamily: 'Oswald',
//                           fontSize: screenSize > 800 ? 30 : 24,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 validation
//                     ? Text("")
//                     : Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "Please pick a date and time.",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.topLeft,
//           margin: EdgeInsets.all(screenSize * 0.03),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(
//                   Icons.arrow_back_ios,
//                   color: Theme.of(context).iconTheme.color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// );
