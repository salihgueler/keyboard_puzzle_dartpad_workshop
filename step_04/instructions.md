> REMINDER: If you are doing this workshop on the Dartpad website, be sure to click on the application output once the app is running and it is focused.

Now that we have set up our shortcuts. Let's add the actions for it.

We can add the actions in two different ways. As you remember from the previous page, Actions allow for the definition of operations that the application can perform by invoking them with an Intent.

We can either create our own Action type or, use `CallbackAction` and pass our variable. Let's learn about both of them now.

```dart
// Defines an action to remove the texts bound to the `TextEditingController` 
// if it is not empty and if it is empty, it unfocuses from the field. You can 
// see that we bound this action into our `ClearIntent`.
class ClearTextAction extends Action<ClearIntent> {
  ClearTextAction(
      this.controller,
      this.focusNode,
      );

  final TextEditingController controller;
  final FocusNode focusNode;

  // The `invoke` function is triggered each time the related intent is 
  // triggered by the Shortcuts widget.
  @override
  void invoke(covariant ClearIntent intent) {
    if (controller.text.isNotEmpty) {
      controller.clear();
    } else {
      focusNode.unfocus();
    }
  }
}
```

But, our widget tree still does not know which actions are available for the page that we are in. For that purpose, we will use `Actions` widget and pass this action into it.

First let's create our map like we did with shortcuts.

```dart
class _LoginPageState extends State<LoginPage> {
  late FocusNode _focusNode;
  late Map<LogicalKeySet, Intent> _shortcuts;
  late Map<Intent, Action<Intent>> _actions;
  ...
}
```

Now, we assign the variable.

```dart
class _LoginPageState extends State<LoginPage> {
  ...
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'LoginPageNameFieldFocusNode');
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
          const CheckFieldValidity(),
    };
    _actions = <Type, Action<Intent>>{
      // Two problems here: We don't have a TextEditingController _controller 
      // at this point, and this ClearTextAction requires a second 
      // parameter: _focusNode. 
      ClearIntent: ClearTextAction(_controller),
    };
  }
  ...
}
```

```dart
class _LoginPageState extends State<LoginPage> {
  ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: _actions,
        child: DecoratedBox(...),
      ),
    );
  }
  ...
}
```

You can see that under the `Shortcuts` now we have an `Actions` widget to call our actions from. It accepts a map of actions with intents to be able to use them.

<!-- The code won't quite run at this point because of the problems mentioned above. It'd be good to prompt the user to add a TextEditingController themselves or with explicit instruction. -->
If you run the application now, you can see that with the Escape button click, the text is cleared from the field.

Let's learn about the second way of creating an action using a `CallbackAction`.

```dart
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    ...
    super.initState();
    _actions = <Type, Action<Intent>>{
      ClearIntent: ClearTextAction(
        _controller,
        _focusNode,
      ),
      CheckFieldValidity: CallbackAction(
        onInvoke: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
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
}
```

We can see that, `CallbackAction` gives us a chance to write the function directly where it belongs to. You can use it for calling your business logic or calling side effects. In the explanation above, we are adding a `SnackBar` to tell users if the field is empty or not.

Let's see how the implementation looks like in action:

![Step 4 Result](https://raw.githubusercontent.com/salihgueler/keyboard_puzzle_dartpad_workshop/main/step_04/output.gif)

Now that we have what we need. Let's move on to the game page to play the game!
