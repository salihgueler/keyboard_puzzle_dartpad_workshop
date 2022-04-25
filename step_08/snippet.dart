import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final FocusNode _focusNode;
  late final FocusNode _resultFocusNode;
  late final FocusNode _lettersFocusNode;
  int _selectedIndex = 0;
  int _movingIndex = -1;
  final _letters = ['A', 'E', 'P', 'R', 'S'];
  final _result = <String?>[null, null, null, null, null];
  final _possibleResults = [
    ['A', 'P', 'E', 'R', 'S'],
    ['A', 'P', 'R', 'E', 'S'],
    ['A', 'S', 'P', 'E', 'R'],
    ['P', 'A', 'R', 'E', 'S'],
    ['P', 'A', 'R', 'S', 'E'],
    ['P', 'E', 'A', 'R', 'S'],
    ['P', 'R', 'A', 'S', 'E'],
    ['P', 'R', 'E', 'S', 'A'],
    ['R', 'E', 'A', 'P', 'S'],
    ['S', 'P', 'E', 'A', 'R'],
    ['S', 'P', 'A', 'R', 'E'],
  ];

  bool _isGameFinished = false;
  bool _isWordFound = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): const MoveLeftIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight): const MoveRightIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown): const MoveDownIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp): const MoveUpIntent(),
      LogicalKeySet(LogicalKeyboardKey.space): const SelectLetterIntent(),
    };
    _actions = <Type, Action<Intent>>{
      MoveLeftIntent: CallbackAction(onInvoke: (_) => _moveLeft()),
      MoveRightIntent: CallbackAction(onInvoke: (_) => _moveRight()),
      MoveDownIntent: CallbackAction(onInvoke: (_) => _moveVertically()),
      MoveUpIntent: CallbackAction(onInvoke: (_) => _moveVertically()),
      SelectLetterIntent:
          CallbackAction(onInvoke: (_) => _selectMovingElement()),
    };
    _focusNode = FocusNode(debugLabel: 'GamePageFocusNode')..requestFocus();
    _resultFocusNode = FocusNode(debugLabel: 'GamePageResultFocusNode');
    _lettersFocusNode = FocusNode(debugLabel: 'GamePageLettersFocusNode')
      ..requestFocus();
  }

  void _selectMovingElement() {
    if (_resultFocusNode.hasFocus) {
      _updateItem(_letters[_movingIndex], _selectedIndex);
      _movingIndex = -1;
    } else {
      if (_movingIndex == _selectedIndex) {
        _movingIndex = -1;
      } else {
        _movingIndex = _selectedIndex;
      }
    }

    setState(() {});
  }

  void _moveLeft() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
      });
    }
  }

  void _moveRight() {
    if (_selectedIndex < 4) {
      setState(() {
        _selectedIndex++;
      });
    }
  }

  void _moveVertically() {
    if (_lettersFocusNode.hasFocus) {
      _lettersFocusNode.previousFocus();
      _resultFocusNode.requestFocus();
    } else {
      _resultFocusNode.unfocus();
      _lettersFocusNode.requestFocus();
    }
    setState(() {});
  }

  void _updateItem(String item, int index) {
    setState(() {
      _result.removeAt(index);
      _result.insert(index, item);
      final element = _possibleResults.firstWhereOrNull(
        (element) => _listEquality.equals(element, _result),
      );

      _isWordFound = element != null;
      _isGameFinished = _result.whereNotNull().length == 5;
    });

    _maybeShowDialog();
  }

  void _maybeShowDialog() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_isGameFinished) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isWordFound)
                    const Text('Congratulations!')
                  else
                    const Text('Try Again!'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcuts,
      actions: _actions,
      focusNode: _focusNode,
      child: Column(
        children: [
          Focus(
            focusNode: _resultFocusNode,
            child: Wrap(
              children: List<Widget>.generate(
                5,
                (index) => Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _resultFocusNode.hasFocus &&
                              _selectedIndex == index
                          ? Colors.redAccent
                          : _result[index] != null && _result[index]!.isNotEmpty
                              ? Colors.greenAccent
                              : Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _result[index] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Focus(
            focusNode: _lettersFocusNode,
            child: Wrap(
              children: List<Widget>.generate(
                5,
                (index) {
                  final currentLetter = _letters[index];
                  return _result.contains(currentLetter)
                      ? Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color: Colors.white24,
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            border: _movingIndex == index
                                ? Border.all(color: Colors.amberAccent)
                                : (_lettersFocusNode.hasFocus &&
                                        _selectedIndex == index)
                                    ? Border.all(color: Colors.redAccent)
                                    : Border.all(color: Colors.greenAccent),
                          ),
                          child: Center(
                            child: Text(
                              _letters[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.blueAccent,
              Colors.lightBlue,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Center(
              child: Text(
                'Welcome $name',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              flex: 10,
              child: Game(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final FocusNode _focusNode;
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final TextEditingController _controller;

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
      LogicalKeySet(LogicalKeyboardKey.enter): const SubmitFieldIntent(),
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
      SubmitFieldIntent: CallbackAction(
        onInvoke: (_) {
          return Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GamePage(name: _controller.text),
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
                    textInputAction: TextInputAction.next,
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

class SubmitFieldIntent extends Intent {
  const SubmitFieldIntent();
}

class MoveLeftIntent extends Intent {
  const MoveLeftIntent();
}

class MoveRightIntent extends Intent {
  const MoveRightIntent();
}

class MoveDownIntent extends Intent {
  const MoveDownIntent();
}

class MoveUpIntent extends Intent {
  const MoveUpIntent();
}

class SelectLetterIntent extends Intent {
  const SelectLetterIntent();
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

const _listEquality = ListEquality();
