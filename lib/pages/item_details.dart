import "package:flutter/material.dart";
import "package:bagger/models/item.dart";
import "package:bagger/pages/partials/item_form.dart";
import "package:bagger/db/db_helper.dart";
import "package:intl/intl.dart";
import "package:bagger/utils/show_snackbar.dart";

class ItemDetails extends StatefulWidget {
  final Item item;
  final String mode;

  ItemDetails({this.item, this.mode});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final dbHelper = DBHelper.dbInstance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void saveItem(context) {
    _formKey.currentState.save();
    widget.mode == "CREATE" ? _insert(widget.item) : _update(widget.item);
    Navigator.pop(context, widget.item);
  }

  void _insert(item) async {
    await dbHelper.insert(item.toMap());
  }

  void _update(item) async {
    item.updatedAt = DateTime.now();
    await dbHelper.update(item.toMap(), item.id);
  }

  void _handleTitleSave(String title) {
    widget.item.title = title;
  }

  void _handleContentSave(String content) {
    widget.item.content = content;
  }

  void _toggleItemArchive() {

    setState(() {
      widget.item.isArchived = !widget.item.isArchived;
    });

    ShowSnackbar(
      key: _scaffoldkey,
      message: widget.item.isArchived ? "Archived" : "Unarchived",
      snackBarAction:  
        SnackBarAction(
          label: "UNDO",
          textColor: Colors.amber,
          onPressed: () { _toggleItemArchive(); },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context, null);
          },
          icon: Icon(Icons.arrow_back)
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){ _toggleItemArchive(); },
            icon: Icon(Icons.archive),
            color: widget.item.isArchived ? Color(0xFF1b77c1) : null
          ),
          IconButton(
            onPressed: (){ saveItem(context); },
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
              item: widget.item
            )            
          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: (){ },
              icon: Icon(Icons.add_box)
            ),
            Text(
              "Edited ${DateFormat("HH:mm a").format(DateTime.now())}",
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