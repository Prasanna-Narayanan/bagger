import "package:flutter/material.dart";
import "package:bagger/models/item.dart";
import "package:bagger/pages/partials/item_form.dart";

class NewItem extends StatefulWidget {

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  Item item;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
    void initState() {
      super.initState();
      item = new Item();
    }

  
  void saveItem() {
    _formKey.currentState.save();
    Navigator.pop(context, item);
  }

  void _handleTitleSave(String title) {
    print("Title: $title");
    item.title = title;
    setState(() {
    });
  }

  void _handleContentSave(String content) {
    print("Content: $content");
    item.content = content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context, null);
          },
          icon: Icon(Icons.arrow_back)
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){saveItem();},
            icon: Icon(Icons.check)
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ItemForm(
              formKey: _formKey,
              handleTitleSave: _handleTitleSave,
              handleContentSave: _handleContentSave,
            )            
          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.add_box)
            ),
            Text(
              "Edited now",
              style: TextStyle(fontFamily: "Noto")
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.indeterminate_check_box)
            )
          ],
        ),
      ),
    );
  }
}