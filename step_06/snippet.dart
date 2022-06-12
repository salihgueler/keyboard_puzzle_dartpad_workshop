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
    };
    _actions = <Type, Action<Intent>>{
      MoveLeftIntent: CallbackAction(onInvoke: (_) => _moveLeft()),
      MoveRightIntent: CallbackAction(onInvoke: (_) => _moveRight()),
      MoveDownIntent: CallbackAction(onInvoke: (_) => _moveDown()),
      MoveUpIntent: CallbackAction(onInvoke: (_) => _moveUp()),
    };
    _focusNode = FocusNode(debugLabel: 'GamePageFocusNode')..requestFocus();
  }

  void _moveLeft() {}

  void _moveRight() {}

  void _moveDown() {}

  void _moveUp() {}

  // ignore: unused_element
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Column(
          children: [
            Wrap(
              children: List<Widget>.generate(
                5,
                (index) => Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    // TODO #1: Update the Border to display `Colors.redAccent` when the _resultsFocusNode is focused and the local index matches the _selectedIndex.
                    border: Border.all(
                      color:
                          _result[index] != null && _result[index]!.isNotEmpty
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
            const SizedBox(height: 50),
            Wrap(
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
                            border: Border.all(color: Colors.greenAccent),
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
          ],
        ),
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

void main() {
  runApp(const DashatarPuzzleApp());
}

class DashatarPuzzleApp extends StatelessWidget {
  const DashatarPuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: GamePage(name: '@salihgueler'),
      ),
    );
  }
}

const _listEquality = ListEquality();
