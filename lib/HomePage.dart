import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Others.dart';
import 'DatabaseFunction.dart';
import 'Database.dart';
import 'Quiz.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelperFunction.instance;

  List<Map<String, dynamic>> subjects = [
    {
      "_id": 0,
      "name": "Example",
      "inName": "yay",
      "color": "Color(0xff443a49);"
    }
  ];
  late Stream<List<Map<String, dynamic>>> stream;
  String text = 'Test';
  int? d = 1;
  int checkSecond = 0;

  Stream<List<Map<String, dynamic>>> _stream() async* {
    dbHelper.testPrint();
    subjects = await dbHelper.returnAll();
    yield subjects;
  }

  Color colorIn(int index) {
    Map<String, dynamic> mapSubjects = subjects[index];
    Color test = ColorUtils.stringToColor(mapSubjects['color']);
    return test;
  }

  Text textInSubjects(int index) {
    Map<String, dynamic> hello = subjects[index];
    text = hello['inName'].substring(0, 1);
    return Text(
      '$text',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 60,
        color: Colors.white,
      ),
    );
  }

  Text textForShow(int index) {
    Map<String, dynamic> hello = subjects[index];
    text = hello['inName'];
    return Text(
      '$text',
      style: TextStyle(),
    );
  }

  void _checkValidate() async {
    dbHelper.onCreate();
    d = await dbHelper.showRows();
    if(d==0){
      dbHelper.insertSubject('Example','Test','Color(0xff443a49)');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkValidate();
    stream = _stream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: stream,
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 8 / 9,
                        ),
                        itemCount: subjects.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return Quiz(index, subjects[index]['name']);
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final double begin = 0.0;
                                    final double end = 1.0;
                                    final Animatable<double> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<double> doubleAnimation =
                                        animation.drive(tween);
                                    return FadeTransition(
                                      opacity: doubleAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        color: colorIn(index),
                                        child: Center(
                                            child: textInSubjects(index)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        color: Colors.white,
                                        child: Center(
                                          child: textForShow(index),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(5, 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterSubject()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class RegisterSubject extends StatefulWidget {
  RegisterSubject({Key? key}) : super(key: key);

  late final String receive;
  final dbHelper = DatabaseHelper.instance;
  @override
  _RegisterSubjectState createState() => _RegisterSubjectState();
}

class _RegisterSubjectState extends State<RegisterSubject> {
  String subjectName = '';
  String inName = '';
  String color = 'blue';
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelperFunction.instance;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> showingColor() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('色の選択'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text('決定'),
                  onPressed: () {
                    setState(() => currentColor = pickerColor);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _formKey,
        appBar: AppBar(
          title: Text('科目名設定'),
          centerTitle: true,
          leadingWidth: 85,
          leading: TextButton(
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 120,
                          height: 120,
                          color: currentColor,
                          child: InkWell(
                            child: Icon(
                              Icons.palette,
                              color: Colors.white,
                              size: 50,
                            ),
                            onTap: () => showingColor(),
                          ),
                        ),
                      ),
                      margin: EdgeInsets.all(50),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 300,
                    child: TextFormField(
                      //initialValue: 'Test',
                      maxLength: 20,
                      onChanged: (valueName) {
                        subjectName = valueName;
                      },
                      validator: (String? value) {
                        return (value == null) ? '未記入です、何か書いてください' : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "テキストボックス",
                        hintText: "科目名を入力してください",
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 300,
                    child: TextFormField(
                      maxLength: 4,
                      //initialValue: '科目名',
                      onChanged: (valueInName) {
                        inName = valueInName;
                      },
                      validator: (String? value) {
                        return (value == null) ? '未記入です、何か書いてください' : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "テキストボックス",
                        hintText: "省略名を書いてください(4文字)",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('保存'),
                  onPressed:(){
                    if(_formKey.currentState!.validate()) {
                      dbHelper.insertSubject(
                          subjectName, inName, pickerColor.toString());
                      Navigator.of(context).pop();
                      dbHelper.testPrint();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}