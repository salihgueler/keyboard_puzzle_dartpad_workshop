Now that we have focusing mechanism in place, let's setup our mechanism to focus to the field with keyboard operations.

Keyboard operations in Flutter split into 3 important subjects:

- Shortcuts
- Intents
- Actions

**Shortcuts** are key bindings that activate by pressing a key or combination of keys. When the `Shortcuts` widget invokes them, it sends their matching intent to the actions subsystem for fulfillment.

**Actions** allow for the definition of operations that the application can perform by invoking them with an `Intent`. `Actions` can be enabled or disabled, and receive the intent instance that invoked them as an argument to allow configuration by the intent.

**Intents** are representations of actions to be triggered when a key or key combination is triggered from shortcuts.

Now that we know their definitions, let's see them in action!

Let's start off by creating a variable to keep our shortcuts just below the `FocusNode` that we created.

```dart
class _LoginPageState extends State<LoginPage> {
  late final FocusNode _focusNode;
  late final Map<LogicalKeySet, Intent> _shortcuts;
  ...
}
```

After we created the variable, we are expected to create key-value pairs for keyboard key combinations and intents.

Let's start off by creating intents:

```dart
class ClearIntent extends Intent {
  const ClearIntent();
}

class CheckFieldValidity extends Intent {
  const CheckFieldValidity();
}
```

You can see that intents are just representations of what the user wants to do. Let's create shortcuts to represent them now:

```dart
// Services import required to use the LogicalKeyboardKey.
// Add this import to the top of your file with other imports
import 'package:flutter/services.dart';

class _LoginPageState extends State<LoginPage> {
  ...
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'LoginPageNameFieldFocusNode');
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter): const CheckFieldValidity(),
    };
  }
  ...
}
```

Now let's wire them to the widget tree. For that purpose, we will be wrapping our main widget with `Shortcuts`. That widget will help us to build a communication between our keyboard and actions.

```dart
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: DecoratedBox(...),
    );
  }
}
```

Now our shortcuts are part of our page, let's make them functional!
