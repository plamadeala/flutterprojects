import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

void main() {
  //MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Hero Animation Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _backgroundcontroller;
  var backgroundpos = 0.0;

  @override
  void initState() {
    super.initState();
    _backgroundcontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000));
    _backgroundcontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _backgroundcontroller.value = 0;
        _backgroundcontroller.forward();
      }
    });
    _backgroundcontroller.addListener(() {
      setState(() {
        backgroundpos = _backgroundcontroller.value;
      });
    });
    _backgroundcontroller.forward();
  }

  BoxDecoration createDecotration(Color c) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 7.0, // has the effect of softening the shadow
          spreadRadius: 7.0, // has the effect of extending the shadow
          offset: Offset(
            5.0, // horizontal, move right 10
            5.0, // vertical, move down 10
          ),
        )
      ],
      color: c,
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  void initGame(bool pvp) {
    _MyGamePageState.pvp = pvp;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyGamePage(
                  title: "Tris",
                )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text(widget.title),
      ),*/
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0, backgroundpos, backgroundpos * 2, 1],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color(0xFF1CD8D2),
              Color(0xFF93EDC7),
              Color(0xFF1CD8D2),
              Color(0xFF93EDC7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 100,
                height: 100,
                child: Hero(
                    tag: "grid",
                    child: Image(
                      image: AssetImage("assets/image.jpg"),
                      height: 100,
                      width: 100,
                    ))),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  initGame(false);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 300,
                        decoration: createDecotration(Colors.blue[300]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.cyan[50],
                              size: 60.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            Text(
                              'Play',
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 60,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                initGame(true);
              },
              child: Container(
                height: 100,
                width: 300,
                decoration: createDecotration(Colors.pinkAccent),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.insert_emoticon,
                      color: Color(0xFF49a09d),
                      size: 60.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Text(
                      'PVP',
                      style: TextStyle(
                          height: 1, fontSize: 60, color: Colors.white70),
                    ),
                    Icon(
                      Icons.insert_emoticon,
                      color: Colors.pinkAccent[400],
                      size: 60.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 100,
              width: 300,
              decoration: createDecotration(Colors.indigo),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Colors.black87,
                    size: 60.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                        height: 1, fontSize: 60, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//screen of the game
class MyGamePage extends StatefulWidget {
  MyGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  static bool pvp = false;
  bool cupanimation = true;
  final String animationCircle = "circle";
  final String animationCross = "cross";
  final String noAnimationState = "none";
  String winner = "noone";
  double winheight = 0;
  double winwidth = 0;
  Color colorWinner = Colors.red;
  bool circle = false;
  List<String> _cellValue = [];

  void _createboard() {
    for (int i = 0; i < 9; i++) {
      _cellValue.add(noAnimationState);
    }
  }

  void _resetboard() {
    for (int i = 0; i < 9; i++) {
      _cellValue[i] = noAnimationState;
    }
    setState(() {});
  }

  String getcupanimation() {
    if (cupanimation) {
      cupanimation = false;
      return "cup";
    } else {
      return "redo";
    }
  }

  void _checkwin() {
    for (int i = 0; i < 9; i++) {
      if (_cellValue[i] == noAnimationState) {
        break;
      } else if (i == 8) {
        _showDialog();
      }
    }
  }

  Widget createbox(int i) {
    return GestureDetector(
      onTap: () {
        if (_cellValue[i] == noAnimationState) {
          var cir = circle ? animationCircle : animationCross;
          circle = !circle;
          setState(() {
            _cellValue[i] = cir;
          });
        }
        _checkwin();
      },
      child: Container(
        child: FlareActor(
          "assets/animation.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: _cellValue[i],
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Game Finished"),
          content: Container(
            height: 175,
            width: 200,
            child: Column(
              children: <Widget>[
                Text("The winner is $winner"),
                Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  child: FlareActor(
                    "assets/Cup.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "cup",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Container(
              alignment: Alignment.center,
              child: new FlatButton(
                child: new Text("NewGame"),
                onPressed: () {
                  Navigator.of(context).pop();
                  cupanimation = true;
                  _resetboard();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _createboard();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Hero(
              tag: "grid",
              child: Image(
                image: AssetImage("assets/image.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (index) {
                  return createbox(index);
                }),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: winheight,
              width: winheight,
              color: colorWinner,
              child: Text(winner),
            ),
            Hero(
                tag: 'Play',
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      _resetboard();
                    },
                    child: Icon(
                      Icons.loop,
                      color: Colors.black45,
                      size: 80.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                ))
          ],
        ));
  }
}
