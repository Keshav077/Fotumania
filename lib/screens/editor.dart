import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fotumania/models/item_data.dart';
import 'package:fotumania/providers/items_provider.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  final ItemData itemData;

  final bool addService;
  final String serviceId;
  Editor(
    this.serviceId,
    this.itemData,
    this.addService,
  );

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextEditingController _serviceNameController,
      _serviceContentController,
      _serviceImageController;
  bool needDate, needImage, needLocation;

  void initState() {
    super.initState();
    _serviceNameController = TextEditingController(
        text: widget.itemData == null ? '' : widget.itemData.name);
    _serviceContentController = TextEditingController(
        text: widget.itemData == null ? '' : widget.itemData.content);
    _serviceImageController = TextEditingController(
        text: widget.itemData == null ? '' : widget.itemData.imageUrl);
    needDate = widget.itemData == null ? false : widget.itemData.needDate;
    needImage = widget.itemData == null ? false : widget.itemData.needImage;
    needLocation =
        widget.itemData == null ? false : widget.itemData.needLocation;
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Colors.white,
    ),
  );
  bool isLoading = false;
  List<int> keysCount = [];
  int classesCount = 0;
  List<List<List<TextEditingController>>> textEditors = [];

  Widget buildTextField(
      TextEditingController controller, String label, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: border,
          labelText: label,
          labelStyle: TextStyle(color: color),
          filled: true,
          fillColor: Colors.black26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mqs = Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top);
    ItemProvider iProvider = Provider.of<ItemProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: SafeArea(
        top: true,
        child: Scaffold(
          body: Container(
            width: mqs.width,
            height: mqs.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: EdgeInsets.all(20),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          widget.addService ? "Add Service" : "Edit Service",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        buildTextField(
                          _serviceNameController,
                          "Service Name",
                          Colors.white,
                        ),
                        buildTextField(
                          _serviceContentController,
                          "Content",
                          Colors.white,
                        ),
                        buildTextField(
                          _serviceImageController,
                          "Image",
                          Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      needDate = !needDate;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: needDate
                                            ? Colors.white24
                                            : Colors.transparent),
                                    alignment: Alignment.center,
                                    height: mqs.height * 0.05,
                                    child: Text("needDate"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      needLocation = !needLocation;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: needLocation
                                            ? Colors.white24
                                            : Colors.transparent),
                                    alignment: Alignment.center,
                                    height: mqs.height * 0.05,
                                    child: Text("needLocation"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      needImage = !needImage;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: needImage
                                            ? Colors.white24
                                            : Colors.transparent),
                                    alignment: Alignment.center,
                                    height: mqs.height * 0.05,
                                    child: Text("needImage"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!widget.addService)
                          for (int i = 0;
                              i < widget.itemData.classes.length;
                              i++)
                            ClassDetails(
                              itemData: widget.itemData,
                              i: i,
                              iProvider: iProvider,
                            ),
                        if (widget.addService)
                          for (int c = 0; c < classesCount; c++)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          label: Text(
                                            "Add Attribute",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.add,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              keysCount[c]++;

                                              textEditors[c].add([
                                                TextEditingController(),
                                                TextEditingController()
                                              ]);
                                              // print(keysCount);
                                              // print(textEditors);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: mqs.width * 0.03,
                                      ),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          label: Text(
                                            "Delete Attribute",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          icon: Icon(
                                            Icons.delete,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              keysCount[c]--;
                                              // print(keysCount);
                                              textEditors[c].removeLast();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                for (int i = 0; i < keysCount[c]; i++)
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildTextField(
                                            textEditors[c][i][0],
                                            "Key",
                                            Colors.white),
                                      ),
                                      Expanded(
                                        child: buildTextField(
                                            textEditors[c][i][1],
                                            "Value",
                                            Colors.white),
                                        flex: 4,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                      ],
                    ),
                  ),
          ),
          floatingActionButton: isLoading
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.addService)
                      FloatingActionButton(
                        foregroundColor: Theme.of(context).primaryColor,
                        heroTag: 'addclass',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            classesCount++;
                            keysCount.add(0);
                            textEditors.add([]);
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: FloatingActionButton(
                        foregroundColor: Theme.of(context).primaryColor,
                        heroTag: 'save',
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (widget.addService) {
                            List<Map<String, dynamic>> classes = [];
                            for (int c = 0; c < classesCount; c++) {
                              Map<String, dynamic> curClass = {};
                              for (int k = 0; k < keysCount[c]; k++) {
                                if (textEditors[c][k][0].text ==
                                    "carouselImages")
                                  curClass[textEditors[c][k][0].text] =
                                      textEditors[c][k][1].text.split(',');
                                else
                                  curClass[textEditors[c][k][0].text] =
                                      textEditors[c][k][1].text;
                              }
                              classes.add(curClass);
                            }
                            try {
                              await iProvider.addItemToService(
                                serviceId: widget.serviceId,
                                content: _serviceContentController.text,
                                imageUrl: _serviceImageController.text,
                                name: _serviceNameController.text,
                                classes: classes,
                                needDate: needDate,
                                needImage: needImage,
                                needLocation: needLocation,
                                hasClasses: classes.length > 1,
                              );
                            } catch (error) {
                              await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text(
                                      "Something went wrong",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    content: Text(
                                      "Check your connection and retry later!",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            try {
                              await iProvider.editItem(
                                id: widget.itemData.itemId,
                                content: _serviceContentController.text,
                                imageUrl: _serviceImageController.text,
                                name: _serviceNameController.text,
                                classes: widget.itemData.classes,
                                needDate: needDate,
                                needImage: needImage,
                                needLocation: needLocation,
                                hasClasses: widget.itemData.classes.length > 1,
                              );
                            } catch (error) {
                              await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text(
                                      "Something went wrong",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    content: Text(
                                      "Check your connection and retry later!",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.save_rounded),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ClassDetails extends StatelessWidget {
  ClassDetails({
    Key key,
    @required this.itemData,
    @required this.i,
    @required this.iProvider,
  }) : super(key: key);

  final ItemData itemData;
  final int i;
  final ItemProvider iProvider;

  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  itemData.classes.length > 1
                      ? showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              backgroundColor: Colors.blue,
                              title: Text("Are you sure?"),
                              content: Text(
                                  "You are going to delete the class: ${itemData.classes[i]['class']}"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    "Yes",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                ),
                              ],
                            );
                          }).then((value) {
                          if (value == true)
                            iProvider.removeClassFromItem(itemData.itemId, i);
                        })
                      : showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              backgroundColor: Theme.of(context).primaryColor,
                              title: Text("You can't do that"),
                              content: Text(
                                  "A service must have atleast one class!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Ok",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            );
                          });
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  "Delete Class",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          ...itemData.classes[i].keys.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: border,
                          focusedBorder: border,
                          filled: true,
                          fillColor: Colors.black26,
                          labelText: 'Key',
                          labelStyle: Theme.of(context).textTheme.subtitle1,
                        ),
                        controller: TextEditingController(text: e),
                        onChanged: (value) => e = value,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: e == 'carouselImages'
                          ? TextField(
                              maxLines: 6,
                              decoration: InputDecoration(
                                enabledBorder: border,
                                focusedBorder: border,
                                filled: true,
                                fillColor: Colors.black26,
                                labelText: 'Value',
                                labelStyle:
                                    Theme.of(context).textTheme.subtitle1,
                              ),
                              controller: TextEditingController(
                                text: itemData.classes[i][e],
                              ),
                              onChanged: (value) =>
                                  itemData.classes[i][e] = value.split(','),
                            )
                          : TextField(
                              decoration: InputDecoration(
                                enabledBorder: border,
                                focusedBorder: border,
                                filled: true,
                                fillColor: Colors.black26,
                                labelText: 'Value',
                                labelStyle:
                                    Theme.of(context).textTheme.subtitle1,
                              ),
                              controller: TextEditingController(
                                text: itemData.classes[i][e],
                              ),
                              onChanged: (value) =>
                                  itemData.classes[i][e] = value,
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
