import 'dart:convert';
import 'dart:io';

import 'package:edu_flutter/create.dart';
import 'package:edu_flutter/edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Data> _list = [];
  List selected = [];
  int cnt = 0;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    fillList();
  }

  @override
  Widget build(BuildContext context) {
    AppBar secondAppBar = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.cancel_outlined),
        iconSize: 25.0,
        onPressed: () {
          setState(() {
            selected.fillRange(0, selected.length, false);
            cnt = 0;
            isSelected = false;
          });
        },
      ),
      title: FittedBox(
        fit: BoxFit.fitWidth,
      child: Text(
        'Таңдаған жазбалар: $cnt',
        textAlign: TextAlign.center,
      ),
      ),
      centerTitle: true,
      backgroundColor: Colors.lightBlue,
    );
    AppBar mainAppBar = AppBar(
      title: const Text('Jazba'),
      backgroundColor: Colors.lightBlue,
      centerTitle: true,
    );
    FloatingActionButton deleteButton = FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () async {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/main.txt');
        Stream<String> lines = file.openRead().transform(utf8.decoder).transform(const LineSplitter());
        List<String> main = [];
        String s = '';
        try {
          await for (String line in lines) {
            main.add('$line\n');
          }
        } catch (e) {
          print('Error: $e');
        }
        int cntt = -1;
        bool add = false;
        for (int i = 0; i < main.length; i++) {
          if (main[i] == '!%!@@))^\n') {
            cntt++;
            add = !selected[cnt];
            print(add);
          }
          if (add) s += main[i];
        }
        file.writeAsStringSync(s);
        setState(()  {
          for (int i = 0; i < _list.length; i++) {
            if (selected[i]) {
              _list.removeAt(i);
              selected.removeAt(i);
              i--;
            }
          }
          isSelected = false;
          cnt = 0;
        });
      },
      child: const Icon(Icons.delete_outline),
    );
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: (isSelected == false) ? mainAppBar : secondAppBar,
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, mainAxisExtent: 130),
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    isSelected = true;
                    if (selected[index] == true) {
                      selected[index] = false;
                      cnt--;
                      if (cnt == 0) isSelected = false;
                    } else {
                      selected[index] = true;
                      cnt++;
                    }
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    isSelected = true;
                    if (selected[index] == true) {
                      selected[index] = false;
                      cnt--;
                      if (cnt == 0) isSelected = false;
                    } else {
                      selected[index] = true;
                      cnt++;
                    }
                  });
                },
                onTap: () {
                  if (isEmpty(selected)) {
                    setState(() {
                      if (selected[index] == true) {
                        selected[index] = false;
                        cnt--;
                        if (cnt == 0) isSelected = false;
                      } else {
                        selected[index] = true;
                        cnt++;
                      }
                    });
                  } else {
                    _awaitReturnValueFromThirdScreen(
                        context,
                        Data(_list[index].title, _list[index].text,
                            _list[index].dateTime),
                        index);
                  }
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: (selected[index] == true)
                      ? RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue, width: 5),
                          borderRadius: BorderRadius.circular(25),
                        )
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Text(
                        add3points(_list[index].title),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 8)),
                      Text(
                        add3points(_list[index].text),
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 18)),
                      Text(dateFormat(_list[index].dateTime),
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: (isSelected)
            ? deleteButton
            : FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () {
                  _awaitReturnValueFromSecondScreen(context);
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    Data result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Create(),
        ));

    setState(() {
      if (result.text.isNotEmpty || result.title.isNotEmpty) {
        _list.add(result);
        selected.add(false);
      }
    });
  }

  void _awaitReturnValueFromThirdScreen(
      BuildContext context, Data data, int index) async {
    Data result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Edit(
                data: data,
              ),
        ));
    if (result.title != _list[index].title ||
        result.text != _list[index].text) {
        setState(() {
        _list[index] = Data(result.title, result.text, result.dateTime);
        update(index, result);
      });
    }
  }

  String dateFormat(DateTime dateTime) {
    DateTime cur = DateTime.now();
    String s = "";

    if (cur.year != dateTime.year) {
      s = DateFormat('d MMM yyyy').format(dateTime);
    } else if (cur.month != dateTime.month) {
      s = DateFormat('d MMM').format(dateTime);
    } else if (cur.day != dateTime.day) {
      if (cur.day - dateTime.day == 2) {
        s = "Алдыңғы күні сағат ${DateFormat('kk:mm').format(dateTime)}";
      } else if (cur.day - dateTime.day == 1) {
        s = "Кеше сағат ${DateFormat('kk:mm').format(dateTime)}";
      }
    } else if (cur.day == dateTime.day) {
      s = DateFormat('kk:mm').format(dateTime);
    } else {
      s = DateFormat('d MMM').format(dateTime);
    }
    return s;
  }

  String add3points(String s) {
    int cnt = '\n'.allMatches(s).length + 1;
    if (cnt > 1) {
      String s1 = "${s.substring(0, s.indexOf('\n'))}...";
      return s1;
    }
    return s;
  }

  bool isEmpty(List list) {
    bool x = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == true) {
        x = true;
      }
    }
    return x;
  }

  void fillList() async {
    String title = '', text = '', date = '';
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/main.txt');
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(const LineSplitter());
    List<String> main = [];
    try {
      await for (String line in lines) {
        main.add(line);
      }
    } catch (e) {
      print('Error: $e');
    }

    for (int i = 0; i < main.length; i++) {
      if (main[i] == '!%!@@))^') {
        String title = '', text = '', date;
        title = main[i + 1];
        int j = i + 2;
        while (main[j] != '@&)&!(&&') {
          text += main[j];
          j++;
        }
        date = main[j + 1];
        i = j + 1;
        setState(() {
          _list.add(Data(title, text, DateTime.parse(date)));
          selected.add(false);

        });
      }
    }
  }

  void update(int index, Data data) async {
    String title = data.title, text = data.text, date = data.dateTime.toString();
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/main.txt');
    Stream<String> lines = file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    List<String> main = [];
    String s = '';
    int cnt = 0, siz = 0;
    index++;
    try {
      await for (String line in lines) {
        if (line == '!%!@@))^') siz++;
        main.add('$line\n');
      }
    } catch (e) {
      print('Error: $e');
    }

    for (int i = 0; i < main.length; i++) {
      if (main[i] == '!%!@@))^\n') cnt++;
      if (cnt == index) {
        s += '!%!@@))^\n';
        s += '$title\n';
        s += '$text\n';
        s += '@&)&!(&&\n';
        s += '${DateTime.now()}\n';
        i = i + 1 + '\n'.allMatches(text).length + 1 + 1 + 1;
        cnt++;
      }
      else {
        s += main[i];
      }
    }
    print(s);
    file.writeAsStringSync(s);
  }

  void deleteInFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/main.txt');
    Stream<String> lines = file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    List<String> main = [];
    String s = '';
    try {
      await for (String line in lines) {
        main.add('$line\n');
      }
    } catch (e) {
      print('Error: $e');
    }
    int cnt = -1;
    bool add = false;
    for (int i = 0; i < main.length; i++) {
      if (main[i] == '!%!@@))^\n') {
        cnt++;
        add = selected[cnt];
      }
      if (add) s += '${main[i]}\n';
    }
    print(s);
    file.writeAsStringSync(s);
  }
}

class Data {
  String title = '', text = '';
  DateTime dateTime;
  Data(this.title, this.text, this.dateTime);
}
