import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ui/home.dart';

void main() async{
  await Hive.initFlutter();

  runApp(
    MaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      home: Home()
    )
  );
}