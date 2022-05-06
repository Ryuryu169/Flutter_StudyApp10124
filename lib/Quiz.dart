import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'DatabaseFunction.dart';
import 'Others.dart';
import 'main.dart';
import 'dart:async';

class Quiz extends StatefulWidget {
  Quiz(this.index, this.Name);
  final index;
  final Name;

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final dbHelper = DatabaseHelperFunction.instance;
  final dbWord = DatabaseWordFunction.instance;
  final TextEditingController _WordEditer = TextEditingController();
  final TextEditingController _MeanEditer = TextEditingController();

  List<Map<String, dynamic>> subjectMap = [
    {'_id': 0, 'name': 'random', 'inName': 'Random', 'color': 'Random'}
  ];
  List<Map<String, dynamic>> wordMap = [
    {'_id': 0, 'name': 'random', 'mean': 'Random'}
  ];

  late Stream<List<Map<String, dynamic>>> stream;
  String _word = '';
  String _mean = '';
  String textLoad = '';
  var check = 0;
  var i = 0;
  var num = 1;
  bool _isLoading = false;

  void _apply(int index) {
    _word = _WordEditer.text;
    _mean = _MeanEditer.text;
    if (_word.isEmpty || _mean.isEmpty) {
      setState(() => textLoad = 'エラー何か入力してください');
    } else {
      dbWord.updateWord(index + 1, widget.Name, _word, _mean);
    }
  }

  void isEdit(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('編集中'),
            children: [
              LoadingOverlay(
                isLoading: _isLoading,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      TextField(
                        maxLength: 8,
                        controller: _WordEditer,
                        decoration: InputDecoration(labelText: '名前'),
                      ),
                      TextField(
                        maxLength: 8,
                        controller: _MeanEditer,
                        decoration: InputDecoration(labelText: '意味'),
                      ),
                      Text(textLoad),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width:30),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextButton(
                        child: Text('保存'),
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          _apply(index);
                          setState(() => _isLoading = false);
                          print('Done updating');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Quiz(widget.index, widget.Name),
                          ));
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextButton(
                        child: Text('削除', style: TextStyle(color: Colors.red.withOpacity(1.0))),
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          dbWord.deleteWord(index+1);
                          setState(() => _isLoading = false);
                          print('Done updating');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Quiz(widget.index, widget.Name),
                          ));
                        }),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Stream<List<Map<String, dynamic>>> _stream() async* {
    dbWord.onCreate(widget.Name);
    dbWord.testPrint();
    i = (await dbWord.showRows(widget.Name))!;
    wordMap = await dbWord.returnAll();
    yield wordMap;
  }

  Future<void> deleteSubject(int index) async {
    if (index != 0) {
      Map<String, dynamic> string = await wordMap[index];
      dbWord.deleteSubject(string['name']);
    } else {
      print('Error');
    }
  }

  Future<void> showingDialogDelete(int index) async {
    if (index != 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('削除　確認'),
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 100,
                ),
                Center(
                  child: Container(
                    child: Text(
                      '本当にこの科目を削除しても\nよろしいですか？',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 70,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'いいえ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                        child:
                            Text('はい', style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          await deleteSubject(widget.index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: 'BlueGrapes'),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('この科目は削除できません')),
      );
    }
  }

  Future<void> showingDialogPlay() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('クイズ　開始'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizIn(widget.index, wordMap, widget.Name),
                  ),
                );
              },
              child: Text("スタート"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    stream = _stream();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: 'BlueGrapes'),
              ),
            ),
          ),
          title: Text(widget.Name),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  setState(() {
                    dbWord.insertWord(widget.Name, "Grapes", "ブドウ");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Quiz(widget.index, widget.Name),
                      ),
                    );
                  });
                }),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => showingDialogPlay(),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showingDialogDelete(widget.index),
            ),
          ],
        ),
        body: Center(
          child: StreamBuilder(
              stream: stream,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '言葉',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 100),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '意味',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: i,
                        itemBuilder: (BuildContext context, index) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Card(
                                  child: Container(
                                    height: 80,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        wordMap[index]['name'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Card(
                                  child: Container(
                                    height: 80,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        wordMap[index]['meaning'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      setState(() => isEdit(index)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class QuizIn extends StatefulWidget {
  final dbHelper = DatabaseHelperFunction.instance;
  final dbWord = DatabaseWordFunction.instance;
  final index;
  final Name;
  final List<Map<String, dynamic>> inMap;
  QuizIn(this.index, this.inMap, this.Name);
  @override
  _QuizInState createState() => _QuizInState();
}

class _QuizInState extends State<QuizIn> {
  List result = [0];
  late Timer timer;
  int seconds = 3;

  @override
  void dispose() {
    super.dispose();
    timer.isActive;
  }

  @override
  void initState() {
    seconds = 3;
    super.initState();
    timer = countTimer();
  }

  Timer countTimer() {
    return Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (seconds < 2) {
        timer.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CardsQuiz(1, widget.index, result, widget.inMap, widget.Name),
            ));
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$seconds',
                style: TextStyle(fontSize: 50, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardsQuiz extends StatefulWidget {
  final idNum;
  final index;
  final Name;
  final List result;
  final List<Map<String, dynamic>> inMap;
  CardsQuiz(this.idNum, this.index, this.result, this.inMap, this.Name);
  @override
  _CardsQuizState createState() => _CardsQuizState();
}

class _CardsQuizState extends State<CardsQuiz> {
  final dbWord = DatabaseWordFunction.instance;
  var hidden = 0;
  var totalNum = 0;

  List listResult = [0];

  Widget cards() {
    return FlipCard(
      front: Card(
        child: Container(
          width: 300,
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [textFront(widget.idNum)],
            ),
          ),
        ),
      ),
      back: Card(
        child: Container(
          width: 300,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              textBack(widget.idNum),
              SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      listResult = widget.result;
                      listResult.add(1);
                      whileQuiz();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.circle_outlined, color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      listResult = widget.result;
                      listResult.add(0);
                      whileQuiz();
                    },
                    child: Container(
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.close_outlined, color: Colors.white),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      direction: FlipDirection.VERTICAL,
      flipOnTouch: true,
      speed: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'ギブアップ', 'やり直し'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              cards(),
            ],
          ),
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'ギブアップ':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Quiz(widget.index, widget.Name)));
        break;
      case 'やり直し':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuizIn(widget.index, widget.inMap, widget.Name)));
        break;
    }
  }

  whileQuiz() {
    if (widget.idNum != widget.inMap.length - 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardsQuiz(widget.idNum + 1, widget.index,
                widget.result, widget.inMap, widget.Name),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EndQuiz(widget.index, widget.Name, widget.result),
          ));
    }
  }

  Text textFront(int forId) {
    String text = widget.inMap[forId]['name'];
    return Text(
      '$text',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }

  Text textBack(int forId) {
    String text = widget.inMap[forId]['meaning'];
    return Text(
      '$text',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }
}

class EndQuiz extends StatefulWidget {
  EndQuiz(this.index, this.Name, this.results);
  final index;
  final Name;
  final results;
  @override
  _EndQuizState createState() => _EndQuizState();
}

class _EndQuizState extends State<EndQuiz> {
  bool _isVisible = false;

  Text returnTotal() {
    var correct = 0;
    var percent = 0.0;
    var total = widget.results.length;
    for (int i = 1; i < total; i++) {
      if (widget.results[i] == 1) correct++;
    }
    percent = correct / total * 100;
    return Text(
      '結果：$correct / $total ( $percent %)',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() => _isVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('EndQuiz'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Quiz(widget.index, widget.Name),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.home_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'BlueGrapes'),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Image(image: AssetImage("assets/images/welldone.png")),
              ),
              SizedBox(height: 80),
              Container(child: Text('お疲れ様です！', style: TextStyle(fontSize: 30))),
              SizedBox(height: 40),
              returnTotal(),
            ],
          ),
        ),
      ),
    );
  }
}
