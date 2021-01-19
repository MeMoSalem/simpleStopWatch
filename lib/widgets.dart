

import 'package:flutter/material.dart';

myButton({var buttonColor, var buttonTitle, Function onButtonClicked}){

  return RaisedButton(
      color: buttonColor,
      elevation: 5.0,
      child: Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(buttonTitle, style: TextStyle(color: Colors.white, fontSize: 18.0),),
      )),
      onPressed: onButtonClicked);

}