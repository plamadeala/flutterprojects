import 'dart:io';

List<ChatClient> clients = [];

void main() {
  Messaggi = new List();
  ServerSocket server;
  ServerSocket.bind("192.168.43.60", 8888).then((ServerSocket socket) {
    server = socket;
    print(server.address.address);
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print("Connected:");
  clients.add(ChatClient(client));
}

void removeClient(ChatClient client) {
  clients.remove(client);
}

List<String> Messaggi;

class ChatClient {
  Socket _socket;
  String get address => _socket.remoteAddress.address;
  int get port => _socket.remotePort;
  User user = new User();

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) {
    String instruction = new String.fromCharCodes(data).trim();
    int instructionCode = int.parse(instruction[0]);
    String instructionData = instruction.substring(1);
    print(instructionCode);
    switch (instructionCode) {
      case 1: //nuovo utente
        {
          var userData = instructionData.split(",");
          print("nuovo utente");
          try {
            user.name = userData[0];
            user.surname = userData[1];
          } catch (e) {
            print("$e");
          }
          if (user.isNotNull()) {
            String msg = "";
            for (int i = 0; i < Messaggi.length; i++) {
              msg += Messaggi[i] + "|";
            }
            _socket.write("0" + msg);
          }
          break;
        }
      case 2:
        {
          print("nuovo messaggio:" + instructionData);

          Messaggi.add(instructionData);
          clients.forEach((client) {
            client._socket.write("0" + instructionData);
          });
          break;
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {}
}

class User {
  String _name;
  String _surname;

  String get name => this._name;
  String get surname => this._surname;

  set name(String name) => this._name = name;
  set surname(String surname) => this._surname = surname;

  bool isNotNull() {
    return this._name != null && this._surname != null ? true : false;
  }

  String toString() {
    return this._name + "|" + this._surname + "|";
  }
}
