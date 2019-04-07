import 'dart:convert';
import "dart:math";

import 'package:bagger/items_list.dart';
import 'package:bagger/pages/item_details.dart';
import "package:flutter/material.dart";
import "package:bagger/models/item.dart";
import "package:bagger/pages/voice_record.dart";
// import "package:http/http.dart" as http;
import "package:bagger/db/db_helper.dart";


class BaggerHome extends StatefulWidget {
  
  @override
  _BaggerHomeState createState() => _BaggerHomeState();
}

class _BaggerHomeState extends State<BaggerHome> {

  List<Item> itemsList = <Item>[];
  List<Widget> baggerHomeList;
  final GlobalKey _apiContainerKey = new GlobalKey();
  bool isShowingArchive = false;

   final DBHelper dbHelper = DBHelper.dbInstance;

  bool isAPICallMade = false;  
  var res;

  @override
  void initState() {
    super.initState();
    _initItemsList();
    baggerHomeList = new List<Widget>();
  }

  Future<void> _initItemsList() async{ 
    var rows = await dbHelper.all();
    List<Item> items = <Item>[];
    setState(() {
      for (var row in rows) 
        items.insert(0, Item.fromMap(row));
      itemsList = items;
    });
  }

  void _buildArchiveList() async {

    if(Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    var rows = await dbHelper.archivedItems();
    List<Item> items = <Item>[];
    for(var row in rows) {
      items.insert(0, Item.fromMap(row));
    }

    setState(() {
      itemsList = items;
      isShowingArchive = true;
    });
  }

  void _handleNewItem() async {
    var item = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ItemDetails(item: Item(), mode: "CREATE")
    ));

    this.setState(() {
      if(item != null)
        itemsList.insert(0, item);
    });
  }

  void _viewItem(int i) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ItemDetails(item: itemsList[i], mode: "EDIT")
    ));
  }

  // Future<Null> _makeAPICall() async {
  //   String url = "https://free-nba.p.rapidapi.com/games/${Random().nextInt(10)}";

  //   setState(() {
  //         isAPICallMade = true;
  //   });

  //   final response = await http.get(url, headers: {
  //     'X-RapidAPI-Host': 'free-nba.p.rapidapi.com',
  //     'X-RapidAPI-Key': 'e3b9f7923bmshbe88cc11642dbe6p1db049jsn2d6e9d4b657c'
  //   });  

  //   setState(() {
  //     res = json.decode(response.body);
  //   });
  // }

  void _handleVoiceRecord() async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => VoiceRecord()
    ));
  }

  void _onItemDismmed(int i) {
    dbHelper.delete(itemsList[i].id);

    setState(() {
      if(itemsList[i] != null)
        itemsList.removeAt(i);
    });

  }

  final topBarActions = <Widget>[
      IconButton(
        icon: Icon(
          Icons.settings,
        ),
        onPressed: (){

        },
      ),
  ];

  Future<void> _refereshList() async {
    await _initItemsList();
  }

  // requires optimisation
  List<Widget> _buildBaggerBody() {

  baggerHomeList = [(
    Flexible(
      child: RefreshIndicator( 
        onRefresh: _refereshList ,
        child: ItemsList(
          itemsList: itemsList, 
          onDismissed: _onItemDismmed, 
          onItemTapped: _viewItem
        )
      )
    )
  )];


    if(isAPICallMade) {
      baggerHomeList.removeWhere((Widget c) => c.key == _apiContainerKey);

      Widget spinner = Container(
        key: _apiContainerKey,
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.height * .5,
        height: MediaQuery.of(context).size.height * .5,
        child:  CircularProgressIndicator(backgroundColor: Theme.of(context).accentColor,)
      );

      Widget apiElement = (res != null) ? Container(
        key: _apiContainerKey,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Match number: ${res['id']}",
              style: TextStyle(fontSize: 18.0)
            ),
            Text(
              "${res['home_team']['full_name']} vs ${res['visitor_team']['full_name']}",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.body1.color
              )
            ),
            Text(
              "${res['home_team_score']} : ${res['visitor_team_score']}",
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.grey
              ),
            ),            
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Divider(height: 10.0)
            )
          ],
        ),
      ) : spinner;

      baggerHomeList.insert(0, apiElement);
    }
    res = null;
    return baggerHomeList;
  }

  Widget _bottomBarButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          onPressed: (){ _handleVoiceRecord(); },
          icon: Icon(Icons.record_voice_over),
        ),
        IconButton(
          onPressed: (){
            // _makeAPICall();
          },
          icon: Icon(Icons.album),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bagger",
          style: TextStyle(fontSize: 25.0)
        ),
        elevation: 0.8,
        centerTitle: true,
        actions: topBarActions,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Prasanna"),
              accountEmail: Text("prasana24n97@gmail.com"),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).textTheme.body1.color,
                child: Text("P"),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).textTheme.body1.color,
                  child: Text("P"),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).textTheme.body1.color,
                  child: Text("W"),
                ),
              ],
            ),
            ListTile(
              onTap: () {
                _buildArchiveList();
              },
              title: Text("Archived List", style: TextStyle(fontFamily: "Noto")),
              trailing: Icon(Icons.archive),
            )
          ],
        )
      ),
      body: Container(
          child: Column(
          mainAxisSize: MainAxisSize.max,
          children: _buildBaggerBody()
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: _bottomBarButtons()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){ _handleNewItem(); },
        child: Icon(
          Icons.add
        ),
      ),
    );
  }
}