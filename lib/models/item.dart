import 'package:flutter/material.dart';

class Item {
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isArchived;
  Color bg;
  List<String> labels;
  int id;

  static int _id = 0;

  var colorsList = [
    0xFF9AECDB, // green accent
    0xFFF8EFBA, //sandal
    0xFFD1D8E0, //blue accent
    0xFFFDA3A3, // red accent
    0xFFC7ECEE, // blue cyan accent
    0xFFFFCCCC, // pinkish
    0xFFFFFFFF, // white
    0xFFAEDDCD, //accent Green
  ];

  Item({this.id, this.title="", this.content="", this.isArchived=false, this.createdAt=null, this.updatedAt=null}){
    // bg = Color(colorsList[_id%colorsList.length]);
    // id = _id;
    // _id++;
    if(this.createdAt == null) createdAt = DateTime.now();
    if(this.updatedAt == null) updatedAt = createdAt;
  }

  updateItem({String title, String content, bool isArchived}) {
    this.title = title;
    this.content = content;
    this.isArchived = isArchived;
    updatedAt = DateTime.now();
  }

  @override
    String toString() {
      // TODO: implement toString
      return "title: $title, content: $content, created_at: $createdAt";
    }

  Map toMap() {
    Map<String, dynamic> map = {
      'title': this.title,
      'content': this.content,
      'created_at': this.createdAt.toString(),
      'updated_at': this.updatedAt.toString(),
      'is_archived': this.isArchived
      // 'id': this.id
    };

    return map;
  }

  static fromMap(Map map) {
    // print(DateTime.parse(map['created_at']));
    return Item(
      id: map['id'], 
      title: map['title'], 
      content: map['content'], 
      createdAt: DateTime.parse(map['created_at']), 
      updatedAt: DateTime.parse(map['updated_at']),
      isArchived: map['is_archived'] == 1
    );
  }
}