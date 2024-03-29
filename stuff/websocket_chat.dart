import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: ChatScreen(),
      );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final String _currentUserId = '9';
  bool _isWriting = false;
  FocusNode keyboardFocus = FocusNode();
  final List<Message> _messages = [];

  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.98:8080'),
  );

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((data) {
      setState(() => _messages.insert(
          0,
          Message.fromMap(
              json.decode(data.toString()) as Map<String, dynamic>)));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Rohit',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.phone),
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    MessageLayout(msg: _messages[index], uid: _currentUserId),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _msgController,
                      focusNode: keyboardFocus,
                      onTap: () => keyboardFocus.requestFocus(),
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onChanged: (val) => setState(() =>
                          _isWriting = val.isNotEmpty && val.trim() != ''),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                    ),
                  ),
                  if (_isWriting)
                    DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Colors.white, size: 25),
                        onPressed: () {
                          if (_msgController.text.isNotEmpty) {
                            _channel.sink.add(
                              json.encode(Message(
                                uid: _currentUserId,
                                from: _currentUserId,
                                msg: _msgController.text.trim(),
                                dt: DateTime.now(),
                              ).toMap()),
                            );
                          }
                          _msgController.clear();
                        },
                      ),
                    )
                  else
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt, size: 28),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.image_rounded, size: 28),
                          onPressed: () {},
                        ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<FocusNode>('keyboardFocus', keyboardFocus));
  }
}

class MessageLayout extends StatelessWidget {
  const MessageLayout({super.key, required this.msg, required this.uid});
  final Message msg;
  final String uid;

  @override
  Widget build(BuildContext context) {
    const messageRadius = Radius.circular(16);
    return Align(
      alignment: msg.uid == uid ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(4, 6, 4, 0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: msg.uid == uid
            ? const BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(
                  topLeft: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius,
                ),
              )
            : const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomRight: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius,
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            msg.msg,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('uid', uid));
    properties.add(DiagnosticsProperty<Message>('msg', msg));
  }
}

class Message {
  const Message({
    required this.uid,
    required this.from,
    required this.msg,
    required this.dt,
  });
  factory Message.fromMap(Map<String, dynamic> map) => Message(
        uid: map['uid'].toString(),
        from: map['from'].toString(),
        msg: map['msg'].toString(),
        dt: map['dt'] as DateTime,
      );
  final String uid, from, msg;
  final DateTime dt;

  Map<String, dynamic> toMap() =>
      <String, dynamic>{'uid': uid, 'from': from, 'msg': msg, 'dt': dt};
}
