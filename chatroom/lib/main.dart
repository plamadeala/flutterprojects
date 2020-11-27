import 'package:chatroom/client/ServerSocket.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //nome della chatroom
  String nome = "not Connected";
  //clsse client usate per connettersi al server
  ServerSocket server;
  //lista che contiene i messaggi
  List<Message> messaggi;
  // controller  dell input del messagigo
  TextEditingController controllerMessaggio;
  TextEditingController controllernome;
  TextEditingController controlleripserver;
  //utente
  User utente;
  //
  String ip;
  //controlla se connesso
  bool connected;

  @override
  void initState() {
    utente = User("nome", "cognome");
    server = new ServerSocket();
    connected = false;
    messaggi = new List();
    controllerMessaggio = new TextEditingController();
    controllernome = new TextEditingController();
    controlleripserver = new TextEditingController();
    super.initState();
  }

  void receive(data) {
    print("ricevuto");

    String instruction = new String.fromCharCodes(data).trim();
    int instructionCode = int.parse(instruction[0]);
    String instructionData = instruction.substring(1);
    print(instruction);
    connected = true;
    switch (instructionCode) {
      case 0:
        {
          var listMessage = instructionData.split("|");
          listMessage.forEach((message) {
            var messaggio = message.split(",");
            if (messaggio.length > 2) {
              messaggi.add(new Message(messaggio[0], messaggio[1],
                  DateTime.parse(messaggio[2]), messaggio[3]));
            }
          });

          break;
        }
      case 1:
        {
          messaggi.add(new Message("nome", "cognome", DateTime.now(), "ciao"));
          break;
        }
    }
    setState(() {});
  }

  void setName(data) {
    setState(() {
      nome = data;
    });
  }

  void onerror(data) {
    setState(() {
      nome = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/photo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: 500,
            width: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(
                  flex: 3,
                ),
                Text(
                  "chatroom",
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
                Spacer(flex: 3),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: controllernome,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'nome'),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: controlleripserver,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'ip server'),
                  ),
                ),
                Spacer(flex: 3),
                GestureDetector(
                  onTap: () {
                    utente = new User(controllernome.text, " ");
                    ip = controlleripserver.text;
                    server.connect(utente, receive, ip);
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    child: Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("nome"),
          ),
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/photo.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messaggi.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        if (messaggi[messaggi.length - index - 1].name ==
                            utente.nome) {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Spacer(),
                                  CreateMessaggio(index),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CreateMessaggio(index),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Container(
                        color: Color.fromARGB(255, 100, 0, 100),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 2, bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllerMessaggio,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Scrivi Messaggio'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  server.send("2" +
                                      utente.nome +
                                      "," +
                                      utente.cognome +
                                      "," +
                                      DateTime.now().toString() +
                                      "," +
                                      controllerMessaggio.text);
                                  controllerMessaggio.text = "";
                                  setState(() {});
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  child: Container(
                                      color: Colors.purple,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(Icons.send),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )));
    }
  }

  //crea messaggio
  Widget CreateMessaggio(int pos) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${messaggi[messaggi.length - pos - 1].name}',
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
            Text(
              '${messaggi[messaggi.length - pos - 1].message}',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              '${messaggi[messaggi.length - pos - 1].time}',
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

//classe di un messaggio contiene data ora e se madnato o ricevuto

//
