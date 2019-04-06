import "package:flutter/material.dart";

class ItemForm extends StatelessWidget {
  final formKey;
  final Function handleTitleSave;
  final Function handleContentSave;

  ItemForm({this.formKey, this.handleTitleSave, this.handleContentSave});
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
            onSaved: (String text) => { handleTitleSave(text) },
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Content",
                border: InputBorder.none,
              ),
              onSaved: (String text) { handleContentSave(text); },
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ],
      )
    );
  }
}