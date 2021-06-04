import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeedBack extends StatelessWidget {
  TextEditingController serviceName, feedback;

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Colors.white,
    ),
  );
  Widget buildTextField(TextEditingController controller, String label,
      Color color, int maxlines) {
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
        maxLines: maxlines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          body: Container(
              padding: EdgeInsets.all(10),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        "Feedback",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  buildTextField(serviceName, "Service Used", Colors.white, 1),
                  buildTextField(feedback, "FeedBack", Colors.white, 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Submit"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
