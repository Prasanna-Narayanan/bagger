import "package:flutter/material.dart";

class ShowSnackbar {
  String message;
  GlobalKey<ScaffoldState> key;
  SnackBar snackBar;
  SnackBarAction snackBarAction;

  ShowSnackbar({this.message, this.key, this.snackBarAction}) {
    snackBar = SnackBar(
      content: Text(message),
      action: snackBarAction,
    );

    key.currentState.showSnackBar(snackBar);
  }
}