import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.blueAccent,
            Colors.lightBlue,
            Colors.lightBlueAccent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Image.network(
              'https://docs.flutter.dev/assets/images/dash/Dashatars.png',
              scale: 8,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  labelText: 'Enter your name',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white54),
                ),
                cursorColor: Colors.white,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SizedBox.shrink(),
                  ),
                );
              },
              child: const Text('Start!'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const DashatarPuzzleApp());
}

class DashatarPuzzleApp extends StatelessWidget {
  const DashatarPuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}