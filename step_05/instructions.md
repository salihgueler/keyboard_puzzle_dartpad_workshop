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

<!-- Hm, I actually missed this tip at first, since the background of BlockQuotes looks very similar to the codebase. Maybe put this above the codeblock after the "let's create our keyboard shortcuts" line? -->
> Here is a task for you! You can create your own Intents just like we did before.


Next step is to create the actions to connect our shortcuts.  

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

For binding the shortcuts and actions. We will learn a new widget. Before we were using `Shortcuts` and `Actions` widgets. But, this time we will use something new. We will use a widget called `FocusableActionDetector`.

`FocusableActionDetector` is a widget that combines the functionality of `Actions`, `Shortcuts`, `MouseRegion` and a `Focus` widget to create a detector that defines actions and key bindings, and provides callbacks for handling focus and hover highlights.

Let's add that to our `Game` widget. We will use only `shortcuts`, `actions` and `focusNode`  properties but, there are many more useful properties for us to use.

<!-- I saw this one, but once again it kind of blends in with the codeblock below it. Maybe remove the BlockQUote background and add an Emoji instead? -->
> Another homework for you! Create a focus node, but do not forget to dispose the resources afterwards!

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

Now we have everything setup for our system, after removing all the Drag and Drop related stuff, you can see that our app is idle. But we will fix it in the next step.
