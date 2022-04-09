Now that we have the the login page ready. It is time to wire the game page to it and enable the keyboard navigation on it. 

You can check the snippet on the right side to see the base project for the second part of the tutorial.

We will work mainly on `Game` widget. We will get rid of all the mouse actions and actually use keyboard arrows and keys for playing the game.

First things first, let's create our keyboard shortcuts to do the operations. 

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  final letters = ['A', 'E', 'P', 'R', 'S'];
  ...

  @override
  void initState() {
    super.initState();
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft) : MoveLeftIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight) : MoveRightIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown) : MoveDownIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp) : MoveUpIntent(),
    };
  }
  ...
}
```

> Here is a task for you! You can create your own Intents just like we did before.


