import 'package:flutter/material.dart';

class Item {
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isArchived;
  Color bg;
  List<String> labels;

  static int id = 0;

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

  Item({this.title="", this.content="", this.isArchived=false}){
    bg = Color(colorsList[id%colorsList.length]);

    id++;
    createdAt = DateTime.now();
    updatedAt = createdAt;

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
      return "Title: $title\nContent: $content";
    }
}