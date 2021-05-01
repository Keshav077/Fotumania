import 'package:flutter/material.dart';

class DisplayUserInfo extends StatelessWidget {
  final String _attribute;
  final TextEditingController _valueController;
  final bool _isEditable;

  DisplayUserInfo(this._attribute, this._valueController, this._isEditable);

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Colors.white,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: _valueController,
        readOnly: !_isEditable,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: border,
          labelText: _attribute,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: _isEditable ? Colors.black26 : Colors.transparent,
        ),
      ),
    );
  }
}
