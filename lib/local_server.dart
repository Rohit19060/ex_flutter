import 'dart:io';

import 'package:flutter/material.dart';

class LocalServer extends StatelessWidget {
  const LocalServer({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Local Server'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Local Server',
              ),
              ElevatedButton(
                onPressed: startServer,
                child: Text('Start Server'),
              ),
            ],
          ),
        ),
      );
}

Future<void> startServer() async {
  // ServerSocket serverSocket = await ServerSocket.bind('192.1.0', 8080);
  // for (var interface in await NetworkInterface.list()) {
  //   debugPrint('== Interface: ${interface.name} ==');
  //   for (var addr in interface.addresses) {
  //     debugPrint('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
  //   }
  // }
  // var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  // debugPrint("Server running on IP : ${server.address} On Port : ${server.port}");
  // await for (var request in server) {
  //   request.response
  //     ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
  //     ..write('Hello, world')
  //     ..close();
  // }
//   RawDatagramSocket udpSocket = await RawDatagramSocket.bind('127.0.0.1', 12345);
//   print('UDP socket is bound to ${udpSocket.address.address}:${udpSocket.port}');
// // Listen for incoming messages
//   udpSocket.listen((RawSocketEvent event) {
//     if (event == RawSocketEvent.read) {
//       var datagram = udpSocket.receive();
//       if (datagram != null) {
//         String message = String.fromCharCodes(datagram.data);
//         print('Received message: $message');
//       }
//     }
//   });
// // Send a message
//   udpSocket.send('Hello, UDP!'.codeUnits, InternetAddress('127.0.0.1'), 12346);

  final requests = await HttpServer.bind('localhost', 8888);
  await for (final request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  debugPrint('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType(
        'text',
        'plain',
      )
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}

// class UdpCommunication {
//   RawDatagramSocket? udpSocket;
//   Future<void> initializeSocket() async {
//     udpSocket = await RawDatagramSocket.bind('127.0.0.1', 12345);
//   }

//   void sendMessage(String message, InternetAddress address, int port) {
//     udpSocket?.send(message.codeUnits, address, port);
//   }

//   void listenForMessages(Function(String) onMessageReceived) {
//     udpSocket?.listen((RawSocketEvent event) {
//       if (event == RawSocketEvent.read) {
//         var datagram = udpSocket?.receive();
//         if (datagram != null) {
//           String message = String.fromCharCodes(datagram.data);
//           onMessageReceived(message);
//         }
//       }
//     });
//   }
// }
