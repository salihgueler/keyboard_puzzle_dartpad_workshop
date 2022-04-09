import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode _focusNode;
  late Map<LogicalKeySet, Intent> _shortcuts;
  late Map<Type, Action<Intent>> _actions;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(debugLabel: 'LoginPageNameFieldFocusNode')
      ..requestFocus();
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
      const CheckFieldValidity(),
    };
    _actions = <Type, Action<Intent>>{
      ClearIntent: ClearTextAction(
        _controller,
        _focusNode,
      ),
      CheckFieldValidity: CallbackAction(
        onInvoke: (_) {
          return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _controller.text.isEmpty
                    ? 'Field should not be empty'
                    : 'Field is valid',
              ),
            ),
          );
        },
      ),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: _actions,
        child: DecoratedBox(
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
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (title){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Text(title),
                        ),
                      );
                    },
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
            ],
          ),
        ),
      ),
    );
  }
}

class ClearTextAction extends Action<ClearIntent> {
  ClearTextAction(
      this.controller,
      this.focusNode,
      );

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  void invoke(covariant ClearIntent intent) {
    if (controller.text.isNotEmpty) {
      controller.clear();
    } else {
      focusNode.unfocus();
    }
  }
}

class ClearIntent extends Intent {
  const ClearIntent();
}

class CheckFieldValidity extends Intent {
  const CheckFieldValidity();
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