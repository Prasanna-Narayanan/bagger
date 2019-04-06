import 'dart:convert';
import "dart:math";

import 'package:bagger/items_list.dart';
import "package:flutter/material.dart";
import "package:bagger/models/item.dart";
import "package:bagger/pages/new_item.dart";
import "package:bagger/pages/voice_record.dart";
import "package:http/http.dart" as http;
import "package:bagger/db/db_helper.dart";


class BaggerHome extends StatefulWidget {

  @override
  _BaggerHomeState createState() => _BaggerHomeState();
}

class _BaggerHomeState extends State<BaggerHome> {

  List<Item> itemsList = <Item>[];
  List<Widget> baggerHomeList;
  final GlobalKey _apiContainerKey = new GlobalKey();

   final DBHelper dbHelper = DBHelper.dbInstance;

  bool isAPICallMade = false;  
  var res;

  @override
  void initState() {
    super.initState();
    _initItemsList();
    baggerHomeList = new List<Widget>();
  }

  // void _getItemList() {
  //   // itemsList.add(Item(title: "Google Pixel XL", content: "Laborum nulla fugiat ex qui Lorem excepteur culpa dolore. Ea id voluptate mollit proident. Et ex velit eiusmod et culpa laborum ut. Aute tempor eiusmod aliqua minim culpa laborum consectetur."));

  //   // itemsList.add(Item(title: "Samsung S10", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "IPhone X", content: "Non culpa elit ullamco magna ea aliquip nostrud officia adipisicing laboris. Cupidatat et nostrud aliqua cillum Lorem minim do irure enim voluptate. Labore do ad aute laborum laboris velit ullamco laboris nulla ad consectetur id. Esse non ex consequat ad ea minim eiusmod voluptate officia ullamco incididunt et deserunt. Magna voluptate exercitation et fugiat. Quis do dolore proident do enim consectetur sint quis sunt non proident consectetur."));

  //   // itemsList.add(Item(title: "IPhone XS", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "One Plus 6T", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "Poco", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "Mi Note 5 Pro", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "Samsung S10", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   // itemsList.add(Item(title: "Google Pixel 3 XL", content: "Aliquip nostrud pariatur esse mollit quis in consectetur duis nulla quis cillum. Aute eiusmod culpa elit et aliquip labore proident ea Lorem aute. Cillum velit commodo fugiat ea magna quis."));

  //   _getItemList();
  // }

  Future<void> _initItemsList() async{ 
    var rows = await dbHelper.all();
    List<Item> items = <Item>[];
    setState(() {
      for (var row in rows) {
        items.insert(0, Item.fromMap(row));
      }
      itemsList = items;
    });
  }

  void _handleNewItem() async {
    var item = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => NewItem()
    ));

    this.setState(() {
      print(item.toMap()['title']);
      if(item != null)
        itemsList.insert(0, item);
    });
  }

  Future<Null> _makeAPICall() async {
    String url = "https://free-nba.p.rapidapi.com/games/${Random().nextInt(10)}";

    setState(() {
          isAPICallMade = true;
    });

    final response = await http.get(url, headers: {
      'X-RapidAPI-Host': 'free-nba.p.rapidapi.com',
      'X-RapidAPI-Key': 'e3b9f7923bmshbe88cc11642dbe6p1db049jsn2d6e9d4b657c'
    });  

    setState(() {
      res = json.decode(response.body);
    });

    print(res['home_team']['name']);
  }

  void _handleVoiceRecord() async {
    var item = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => VoiceRecord()
    ));
  }

  void _onItemDismmed(int i) {
    setState(() {
      if(itemsList[i] != null)
        itemsList.removeAt(i);
      print(itemsList.length);
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
    print("refreshing");
    await _initItemsList();
  }

  List<Widget> _buildBaggerBody() {

  baggerHomeList = [(
    Flexible(
      child: RefreshIndicator( 
        onRefresh: _refereshList ,
        child: ItemsList(itemsList: itemsList, onDismissed: _onItemDismmed)
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
            _makeAPICall();
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
      drawer: Drawer(),
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