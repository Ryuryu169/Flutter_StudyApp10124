import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'DatabaseFunction.dart';
import 'Database.dart';
import 'Others.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final dbHelper = DatabaseHelper.instance;

  late Stream<List<Map<String, dynamic>>> _Stream;
  bool _isLoading = false;
  var d = 0;

  List<Map<String, dynamic>> subjects = [{
    "_id": 0,
    "name": "Example",
    "inName": "yay",
    "color": "Color(0xff443a49);"
  }];

  Stream<List<Map<String, dynamic>>> _stream() async* {
    d = (await dbHelper.queryRowCount())!;
    yield subjects;
  }

  Future<void> deleteSubject() async {
    for (int i = 1; i < d; i++) {
      var k = dbHelper.delete(i);
      print(k);
    }
  }

  Future<void> showingDeleteSubjects() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: const Text('全科目削除'), children: [
            LoadingOverlay(
              child: Column(
                children: <Widget>[
                  SizedBox(height:40),
                  Text('本当に削除してもよろしい\nですか？',style: TextStyle(fontSize:20)),
                  SizedBox(height:40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 140),
                      TextButton(
                          child:
                              Text('削除', style: TextStyle(color: Colors.blue)),
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            await deleteSubject();
                            setState(() => _isLoading = false);
                          }),
                      TextButton(
                        child: Text('キャンセル',
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
              isLoading: _isLoading,
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(),
            ),
          ]);
        });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _Stream = _stream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _Stream,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.badge),
                        title: Text('プロフィール'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileSettings(0),
                            ),
                          );
                        },
                      ),
                    ),
                    height: 70,
                  ),
                  SizedBox(
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.help),
                        title: Text('説明書き'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IntroductionPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    height: 70,
                  ),
                  SizedBox(
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('全科目の削除'),
                        onTap: () => showingDeleteSubjects(),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                    height: 70,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPage createState() => _IntroductionPage();
}

class _IntroductionPage extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExplainPage(),
    );
  }
}

class ExplainPage extends StatefulWidget {
  @override
  _ExplainPage createState() => _ExplainPage();
}

class _ExplainPage extends State<ExplainPage>{
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyApp()),
    );
  }
  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      /*globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: _buildImage('splash.png', 100),
          ),
        ),
      ),*/
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'スキップ',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "説明画面",
          body: "他に分からないことは開発者まで",
          image: _buildImage('settings.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'プロフィール画面',
          body: "得意科目などの設定ができます",
          image: _buildImage('mypage.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "プロフィール設定画面（開発途中）",
          body: "自分のアイコンや名前が登録できます",
          image: _buildImage('houhu.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "科目登録画面",
          body: "ここで自分の科目が登録できます",
          image: _buildImage('homepage.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "単語登録画面",
          body: "ここで単語や意味の編集ができます",
          image: _buildImage('writequiz.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "クイズ画面",
          body: "実際に答えられたかを〇×で答えてください",
          image: _buildImage('quiz.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "クイズ終了画面",
          body: "結果が出ます。上のアイコンからもう一度遊ぶかやめるかを選べます",
          image: _buildImage('quizfinish.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "設定画面",
          body: "ここでプロフィールの設定、科目の管理ができます",
          image: _buildImage('setting.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('終わり', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)
          ),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)
          ),
        ),
      ),
    );
  }
}

class ProfileSettings extends StatefulWidget {
  final i;
  ProfileSettings(this.i);
  @override
  _ProfileSettings createState() => _ProfileSettings();
}

class _ProfileSettings extends State<ProfileSettings> {
  final dbProfile = DatabaseProfileFunction.instance;
  final TextEditingController _Textcontroller = TextEditingController();
  final TextEditingController _Favoritecontroller = TextEditingController();
  final TextEditingController _Namecontroller = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  var check = 0;
  var _message = '';
  var _name = '';
  var _favorite = '';
  bool _isLoading = false;

  Future<int> _apply() async {
    _message = _Textcontroller.text;
    _name = _Namecontroller.text;
    _favorite = _Favoritecontroller.text;
    if (_message.isEmpty || _name.isEmpty || _favorite.isEmpty) {
      return 1;
    } else {
      dbProfile.deleteProfile(1);
      dbProfile.insertProfile(_name, _favorite, _message, widget.i);
      return 0;
    }
  }

  Image overlayPicture(int i) {
    return Image(
      image: AssetImage("assets/images/$i.png"),
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('アカウント設定'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MyApp()),
            ),
          ),
        ),
        body: ListView(
          children: [
            LoadingOverlay(
              isLoading: _isLoading,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder:(BuildContext context)=>GetImage())),
                              child: overlayPicture(widget.i),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextField(
                                maxLength: 5,
                                controller: _Namecontroller,
                                decoration: InputDecoration(labelText: '名前'),
                              ),
                              TextField(
                                maxLength: 5,
                                controller: _Favoritecontroller,
                                decoration: InputDecoration(labelText: '得意科目'),
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      controller: _Textcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '何か入力してください';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "勉強の抱負を書いてください",
                        prefixIcon: Icon(
                          Icons.edit,
                          color: Colors.black45,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save),
          label: Text('保存'),
          backgroundColor: Colors.blue,
          onPressed: () async {
            setState(() => _isLoading = true);
            check = await _apply();
            setState(() => _isLoading = false);
            if (check == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('エラー'),
                      children: [
                        Container(
                          child: Text('未記入項目があります。全て埋めてから保存してください'),
                          padding: EdgeInsets.all(20),
                        ),
                        TextButton(
                            child: Text('了解'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class GetImage extends StatefulWidget {
  @override
  _GetImage createState() => _GetImage();
}

class _GetImage extends State<GetImage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1 / 1,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ProfileSettings(index);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final double begin = 0.0;
                        final double end = 1.0;
                        final Animatable<double> tween =
                            Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: Curves.easeInOut));
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
                child: Image(
                  image: AssetImage("assets/images/$index.png"),
                ),
              );
            }),
      ),
    );
  }
}
