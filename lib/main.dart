import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stomp_message_example/socket_handler.dart';
import 'package:flutter_stomp_message_example/theme_view_model.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

void main() {
  runApp(ThemeViewModel(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeViewModel.of(context)!.theme,
      builder: (BuildContext context, ThemeData themeData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Stomp Message Example App',
          theme: themeData,
          home: const MyHomePage(title: 'Flutter Stomp Message Example App'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SocketHandler socketHandler = SocketHandler();

  @override
  void initState() {
    // TODO: implement initState
    socketHandler.stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8100/ws',
        onConnect: (StompFrame connectFrame) {
          // client is connected and ready
          print("Connecting...");
          socketHandler.stompClient.subscribe(
            destination: '/all/messages',
            headers: {},
            callback: (frame) {
              setState(() {});
            },
          );
        },
        webSocketConnectHeaders: {
          "transports": ["websocket"],
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                socketHandler.stompClient.activate();
              },
              child: const Text("Socket Client Activate"),
            ),
            ElevatedButton(
              onPressed: () {
                socketHandler.stompClient.send(
                    // destination: '/user/specific',
                    destination: '/app/application',
                    body: jsonEncode({"message": "Hi"}));
                setState(() {});
              },
              child: const Text("Send Message \"Hi\" "),
            ),
          ],
        ),
      ),
    );
  }
}
