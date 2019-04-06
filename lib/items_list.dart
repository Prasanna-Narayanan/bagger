import "package:flutter/material.dart";
import "package:bagger/models/item.dart";

class ItemsList extends StatelessWidget {
  final List<Item> itemsList;
  final Function onDismissed;

  ItemsList({this.itemsList, this.onDismissed});

  String printInDouble(int t) {
    return t < 10 ? "0$t" : t.toString();
  }

  String _formatDate(DateTime dt) {
    var diff = DateTime.now().difference(dt);
    
    dt = dt.toLocal();

    String relativeTime;

    switch(diff.inDays) {
      case 0:
        relativeTime = "Today ${printInDouble(dt.hour)}:${printInDouble(dt.minute)}";
        break;
      case 1:
        relativeTime = "Yesterday ${printInDouble(dt.hour)}:${printInDouble(dt.minute)}";
        break;
      default:
        relativeTime = "${dt.day}, ${printInDouble(dt.hour)}:${printInDouble(dt.minute)}";
    }
    return relativeTime;
  }

  Widget _archivedList(int index) {
    var item = itemsList[index];
    
    if(item.isArchived) {
      return RotatedBox(
        quarterTurns: 3,
        child: Text("Archived"),
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0
      );
    }
  }

  _handleDismiss(dir, i) {
    print(i);
    onDismissed(i);
  }

  Widget _buildListTile(int i, bool isColored, BuildContext context) {
    return Column(
      children: <Widget>[
        Dismissible(
            key: UniqueKey(),
            onDismissed: (dir) { _handleDismiss(dir, i); },
            background: Container(color: Theme.of(context).accentColor),
            child: ListTile(
            onTap: () {},
            // leading: _archivedList(i),
            title: Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      itemsList[i].title,
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color, fontSize: 24.0, fontFamily: "Cookie"),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    _formatDate(itemsList[i].updatedAt),
                    style: TextStyle(fontSize: 16.0,color: Colors.black45, fontFamily: "Cookie")
                  )
                ],
              ),
            ),
            subtitle: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                itemsList[i].content,
                style: TextStyle(
                  fontFamily: "Cookie",
                  fontSize: 18.0
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0), 
          child: Divider(height: 10.0)
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (context, i) => Container(
          padding: EdgeInsets.only(bottom: 10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              // color:  widget.itemsList[i].bg
          ),
          child: _buildListTile(i, true, context)
        )
      )
    );
  }
}