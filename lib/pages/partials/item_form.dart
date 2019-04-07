import 'package:bagger/models/item.dart';
import "package:flutter/material.dart";

class ItemForm extends StatelessWidget {
  final formKey;
  final Function handleTitleSave;
  final Function handleContentSave;
  final Item item;

  ItemForm({this.formKey, this.handleTitleSave, this.handleContentSave, this.item});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: "Rancho", 
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5
            ),
            decoration: InputDecoration(
              hintText: "Title",
              border: InputBorder.none,
            ),
            initialValue: item.title,
            onSaved: (String text) => { handleTitleSave(text) },
          ),
          Container(
            child: TextFormField(
              style: TextStyle(
                fontFamily: "Rancho", 
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                hintText: "Content",
                border: InputBorder.none,
              ),
              onSaved: (String text) { handleContentSave(text); },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              initialValue: item.content,
            ),
          ),
        ],
      )
    );
  }
}