import 'package:app/models.dart';
import 'package:app/screens/wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
//  final WheelService _wheelService = WheelService();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => WheelService(),
      child: MaterialApp(
        title: 'Lantastic',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WheelScreen(
                wheelId: "main",
              ),
        },
      ),
    );
  }
}
