import 'package:flutter/material.dart';
import 'main.dart';
import 'package:intl/intl.dart';


class Edit extends StatefulWidget {
  Data data = Data('', '', DateTime.now());
  Edit({Key? key, required this.data}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {

  var title = TextEditingController();
  var text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      title.text = widget.data.title;
      text.text = widget.data.text;
    });
    return WillPopScope(
      onWillPop: () {
        _sendDataBack(context);
        return Future.value(false);
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Icon(Icons.keyboard_backspace_sharp, size: 30,),
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
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: text,
                  style: const TextStyle(fontSize: 18),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Соңғы жазған уақыты: ${dateFormat(widget.data.dateTime)}", textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );

  }

  void _sendDataBack(BuildContext context) {
    DateTime date = DateTime.now();
    Data dataToSendBack = Data(title.text, text.text, date);
    setState(() {
      title.clear();
      text.clear();
    });
    Navigator.pop(context, dataToSendBack);
  }
  String dateFormat (DateTime dateTime) {

    DateTime cur = DateTime.now();
    String s = "";

    if (cur.year != dateTime.year) {
      s = DateFormat('d MMM yyyy').format(dateTime);
    }
    else if (cur.month != dateTime.month) {
      s = DateFormat('d MMM').format(dateTime);
    }
    else if (cur.day != dateTime.day) {
      if (cur.day - dateTime.day == 2) {
        s = "Алдыңғы күні сағат ${DateFormat('kk:mm').format(dateTime)}";
      }
      else if (cur.day - dateTime.day == 1) {
        s = "Кеше сағат ${DateFormat('kk:mm').format(dateTime)}";
      }
    }
    else if (cur.day == dateTime.day) {
      s = DateFormat('kk:mm').format(dateTime);
    }
    else {
      s = DateFormat('d MMM').format(dateTime);
    }
    return s;
  }
}
