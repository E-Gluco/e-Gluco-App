// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gluco/styles/customcolors.dart';

AppBar defaultAppBar({title, trailing, bool centertitle = false}) => AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey[800],
      centerTitle: centertitle,
      actions: trailing,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
