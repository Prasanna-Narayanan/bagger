import "package:flutter/material.dart";
import "package:bagger/models/item.dart";
import "package:bagger/pages/partials/item_form.dart";
import "package:bagger/db/db_helper.dart";

class NewItem extends StatefulWidget {

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  Item item;
  final dbHelper = DBHelper.dbInstance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
    void initState() {
      super.initState();
      item = new Item();
    }

  
  void saveItem() {
    _formKey.currentState.save();
    _insert(item);
    Navigator.pop(context, item);
  }

  void _insert(item) async {
    await dbHelper.insert(item.toMap());

    int rowCount = await dbHelper.rowCount();
    print("ROWS: $rowCount");
  }

  void _handleTitleSave(String title) {
    item.title = title;
  }

  void _handleContentSave(String content) {
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