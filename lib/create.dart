import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  static var title = TextEditingController();
  static var text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            child: const Icon(
              Icons.keyboard_backspace_sharp,
              size: 30,
            ),
            onPressed: () {
              _sendDataBack(context);
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Container(
              margin: const EdgeInsets.all(15),
              child: TextFormField(
                controller: title,
                style: const TextStyle(fontSize: 25),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Тақырып',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Container(
              margin: const EdgeInsets.all(15),
              child: TextFormField(
                style: const TextStyle(fontSize: 18),
                controller: text,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Енгізуді бастау',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendDataBack(BuildContext context) {

    DateTime date = DateTime.now();
    Data dataToSendBack = Data(title.text, text.text, date);
    if (title.text.isNotEmpty || text.text.isNotEmpty) {
      addnote(dataToSendBack);
    }
    setState(() {
      title.clear();
      text.clear();
    });
    Navigator.pop(context, dataToSendBack);
  }

  Future<void> addnote(Data data) async {
    String title = '', text = '', date = '';
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/main.txt');
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());
    String main = '';
    try {
      await for (String line in lines) {
        main += '$line\n';
      }
    } catch (e) {
      print('Error: $e');
    }
    main += '!%!@@))^\n${data.title}\n${data.text}\n@&)&!(&&\n${data.dateTime}\n';
    file.writeAsStringSync(main);
  }
}
