We will start off with the `LoginPage` widget. At the moment, the widget contains a nice Dash image, a `TextField` and an `ElevatedButton` inside a `Column` .

Users are expected to write their names to move to the next page and the control mechanism only works with a button click at the moment.

Let's start off by removing the button related code below:

```dart
Expanded(
    flex: 1,
        child: ElevatedButton(
        onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GamePage(),
                ),
            );
        },
        child: const Text('Start!'),
    ),
),
```

After this, we need a way to be able to focus on the text field. We will be using `FocusNode`s for that purpose.

`FocusNode` is an important object to implement focusing on an item or creating a set of focusable objects. They are long-lived objects that hold the focus state and attributes. This way they can persist between builds.

Let's add a `FocusNode` at the `_LoginPageState` class level like the following:

```dart
class _LoginPageState extends State<LoginPage> {
  late final FocusNode _focusNode;
  ...
}
```

Now that we defined the variable, let's assign the variable. For that, let's override `initState` from the `State` class and assign the variable. Also let's `requestFocus` focus so in the beginning the field is automatically focused.

```dart
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'LoginPageNameFieldFocusNode')..requestFocus();
  }
}
```

You can see that, we added a `debugLabel` property to our object and the reason is to help us debug focus related problems.

One thing to mention here is, it is advised to use `FocusNode` with `StatefulWidget`s to be able to dispose the resources in it when the widget is no longer attached to the widget tree. For disposing, let's override `dispose` function and dispose the resources from the focus node.

```dart
class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
```

Before we move to next step, let's add the `_focusNode` to the `TextField` under our `build` function.

```dart

class _LoginPageState extends State<LoginPage> {
  ...
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ...
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            ...
            TextField(
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
        ],
      ),
    );
  }
}
```
