import 'dart:convert';
import 'dart:io';
import 'package:edu_flutter/create.dart';
import 'package:edu_flutter/edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var items = [
    'Кіші',
    'Орташа',
    'Үлкен',
  ];
  String val = 'Орташа';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Настройки"),
          backgroundColor: Colors.lightBlue,
          leading: IconButton(icon: const Icon(Icons.keyboard_backspace_sharp),
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ),
        body: DropdownButton(
          value: val,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Card(
                shape: RoundedRectangleBorder(
                  //side: const BorderSide(color: Colors.blue, width: 5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child:  Text(items),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              val = newValue!;
            });
          },

        ),
      ),
    );
  }
  PopupMenuItem _buildPopupMenuItem(String title) {
    return PopupMenuItem(
      child:  Row(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
