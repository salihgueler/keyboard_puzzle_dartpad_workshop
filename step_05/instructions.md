# Set up the Game Page

> REMINDER: If you are doing this workshop on the Dartpad website, be sure to click on the letter boxes once the app is running and it gets the initial focus.

Now that you have the the login page ready. It is time to clean up the game page and enable the keyboard navigation on it. 

You can check the snippet on the right side to see the base project for the second part of the tutorial.

You will work mainly on `Game` widget. You will get rid of all the mouse actions and actually use keyboard arrows and keys for playing the game.

First things first, let's create your keyboard shortcuts to do the operations. 

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  final _letters = ['A', 'E', 'P', 'R', 'S'];
  ...

  @override
  void initState() {
    super.initState();
    // Make sure to create the Intent Classes!
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft) : const MoveLeftIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight) : const MoveRightIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown) : const MoveDownIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp) : const MoveUpIntent(),
    };
  }
  ...
}
```


> 📝 Here is a task for you! You can create your own Intents just like you did before.


Next step is to create the actions to connect your shortcuts.  

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  ...
  @override
  void initState() {
      super.initState();
      ...
      _actions = <Type, Action<Intent>>{
        MoveLeftIntent: CallbackAction(onInvoke: (_) => _moveLeft()),
        MoveRightIntent: CallbackAction(onInvoke: (_) =>_moveRight()),
        MoveDownIntent: CallbackAction(onInvoke: (_) => _moveDown()),
        MoveUpIntent: CallbackAction(onInvoke: (_) => _moveUp()),
      };
  }

  void _moveLeft() {}

  void _moveRight() {}

  void _moveDown() {}

  void _moveUp() {}
  ...
}
```

For binding the shortcuts and actions. You will learn a new widget. Before you were using `Shortcuts` and `Actions` widgets. But, this time you will use something new. You will use a widget called `FocusableActionDetector`.

`FocusableActionDetector` is a widget that combines the functionality of `Actions`, `Shortcuts`, `MouseRegion` and a `Focus` widget to create a detector that defines actions and key bindings, and provides callbacks for handling focus and hover highlights.

Let's add that to your `Game` widget. You will use only `shortcuts`, `actions` and `focusNode`  properties but, there are many more useful properties for us to use.


> 📝 Another homework for you! Create a focus node, but do not forget to dispose the resources afterwards!

```dart
@override
Widget build(BuildContext context) {
  return FocusableActionDetector(
    shortcuts: _shortcuts,
    actions: _actions,
    focusNode: _focusNode,
    child: Column(...),
  );
}
```

Now you have everything setup for your system, after removing all the Drag and Drop related stuff, you can see that your app is idle. But you will fix it in the next step.

<img alt="Google Analytics" src="https://www.google-analytics.com/collect?v=1&cid=1&t=pageview&ec=workshop&ea=open&dp=blob/main/step_05/instructions.md&dt=/intro&tid=UA-228112532-1" style="width: 1px; height: 1px"/>