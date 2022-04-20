> REMINDER: If you are doing this workshop on the Dartpad website, be sure to click on the application output once the app is running and it is focused.

In the previous step, we added the steps to have a functioning keyboard navigation. Let's make it actually functioning.

First, we will decide on the strategy to follow to keep track of the indexes.

We have two sets of horizontal layout to interact with. We will keep track of the index in the horizontal position and decide on which vertical layout we belong by using `FocusNode`s.

Let's start by defining the layout.

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final FocusNode _focusNode;
  int _selectedIndex = 0;
  ...
}
```

`_selectedIndex` is stationed at 0 to give us a chance to have a starting point.

Now it is time to add functionality to it:

```dart
class _GameState extends State<Game> {
  ...
  void _moveLeft() {
    if (_selectedIndex > 0) {
      _selectedIndex--;
      setState(() {});
    }
  }

  void _moveRight() {
    _selectedIndex++;
    setState(() {});
  }
  ...
}
```

This way we can move our cursor left and right and actually add an affect to it on the screen on the UI.

> New homework time! Add a way to change the border color of the box to `Colors.redAccent` when it is focused and keep it as it is when it is not focused.

Next thing we are going to be doing isto add the vertical navigation.

For that, we will add two `FocusNode`s and add them to the root widgets of the horizontal navigated widgets, which is the `Wrap` widgets.

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final FocusNode _focusNode;
  late final FocusNode _resultFocusNode;
  late final FocusNode _lettersFocusNode;
  ...
  @override
  void initState() {
    super.initState();
    ...
    _focusNode = FocusNode(debugLabel: 'GamePageFocusNode')..requestFocus();
    _resultFocusNode = FocusNode(debugLabel: 'GamePageResultFocusNode');
    _lettersFocusNode = FocusNode(debugLabel: 'GamePageLettersFocusNode')..requestFocus();
  }

  ...

  @override
  void dispose() {
    _focusNode.dispose();
    _resultFocusNode.dispose();
    _lettersFocusNode.dispose();
    super.dispose();
  }
```

We created the `FocusNode`s as we created them before. Now we will add them to the `Wrap` widget and to make it part of the Widget tree. For that, we will use `Focus` widget. Focus is a widget that manages a `FocusNode` to allow keyboard focus to be given to this widget and its descendants.

Let's wrap our `Wrap` widgets with Focus and assign the `FocusNode`s created for them.

```dart
class _GameState extends State<Game> {
  ...
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
            child: Wrap(...),
          ),
          const SizedBox(height: 50),
          Focus(
            focusNode: _lettersFocusNode,
            child: Wrap(...),
          ),
        ],
      ),
    );
  }
  ...
}
```

Lastly we will add our logic to focus and unfocus to the vertical elements with keyboard navigation.

Flutter always expects you to focus on at least one element. But, the focus hierarchy is something that should be controlling. For making the controlling mechanism easier, `FocusNode` has helper functions called `previousFocus` and `nextFocus`. These helps you go through your focus elements without troubling you. But these are not useful in our case. We have 3 different `FocusNodes` and only want to travel between the two of them. That is why we will be using `requestFocus` and `unfocus` funcsions of the `FocusScope` and follow the rule of focusing at least one element all the time.

```dart
class _GameState extends State<Game> {
  ...
  @override
  void initState() {
    super.initState();
    ...
    _actions = <Type, Action<Intent>>{
      MoveLeftIntent: CallbackAction(onInvoke: (_) => _moveLeft()),
      MoveRightIntent: CallbackAction(onInvoke: (_) =>_moveRight()),
      MoveDownIntent: CallbackAction(onInvoke: (_) => _moverVertically()),
      MoveUpIntent: CallbackAction(onInvoke: (_) => _moverVertically()),
    };
    ...
  }

  void _moverVertically() {
    if (_lettersFocusNode.hasFocus) {
      _lettersFocusNode.unfocus();
      _resultFocusNode.requestFocus();
    } else {
      _resultFocusNode.unfocus();
      _lettersFocusNode.requestFocus();
    }
    setState(() {});
  }
  ...
}
```

We removed the up and down functions and combined them into one move vertically function. It checks if one of the nodes has focus and acts accordingly.

Now the current functionality looks like following:
![Step 6 Result](https://raw.githubusercontent.com/salihgueler/keyboard_puzzle_dartpad_workshop/main/step_06/output.gif)

Let's add the last gaming logic to the page and wrap it up!
