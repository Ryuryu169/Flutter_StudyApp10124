import 'package:flutter/material.dart';
import 'DatabaseFunction.dart';
import 'Settings.dart';
import 'dart:async';

class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final dbHelper = DatabaseHelperFunction.instance;
  final dbProfile = DatabaseProfileFunction.instance;

  final String tokui = 'TokuiKamoku';
  final String mokuhyou = 'Mokuhyou';

  late Stream<List<Map<String, dynamic>>> streamSubjects;

  List<Map<String, dynamic>> mapSubjects = [
    {"_id": 1, "name": "Test", "inName": "Test", "color": "Color(0xff443a49);"}
  ];
  Map<String, dynamic> mapProfile = {
    "_id": 1,
    "name": "Test",
    "goal": "Test",
    "favorite": "Test",
    "picture": "Test"
  };

  Stream<List<Map<String, dynamic>>> _streamSubjects() async* {
    dbProfile.onCreate();
    dbProfile.insertProfile("Test", "Math", "BlueGrapes", 0);
    Future.delayed(Duration(seconds: 3), () {});
    dbProfile.testPrint();
    mapProfile = await dbProfile.returnAll();
    mapSubjects = await dbHelper.returnAll();
    yield mapSubjects;
  }

  String forName() {
    var result = mapProfile['name'];
    return result;
  }

  String forFavorite() {
    var result = mapProfile['favorite'];
    return result;
  }

  String forGoal() {
    var result = mapProfile['goal'];
    return result;
  }

  Widget overContainer() {
    var i = mapProfile['picture'];
    return Image(image: AssetImage("assets/images/$i.png"));
  }

  @override
  void initState() {
    super.initState();
    streamSubjects = _streamSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: streamSubjects,
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return ProfileSettings(0);
                              }, transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final double begin = 0.0;
                                final double end = 1.0;
                                final Animatable<double> tween = Tween(
                                        begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                                final Animation<double> doubleAnimation =
                                    animation.drive(tween);
                                return FadeTransition(
                                  opacity: doubleAnimation,
                                  child: child,
                                );
                              }),
                            );
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: overContainer(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  forName(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  forFavorite(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(60, 0, 50, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '目標',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSettings(0),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                      padding: const EdgeInsets.all(15),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        forGoal(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
