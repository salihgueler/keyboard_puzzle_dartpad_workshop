# Increasing the Gamification

You might realise that you have a function called `_updateItem` that is not referenced yet. The reason: that function controls the game mechanism for your project.

Let's create a mechanism to select a letter and move it up.

> 📝 Homework! Add a new keyboard shortcut for space key, an intent and an action to be able to accommodate the selecting mechanism that you are going to be learning below. 
> 
> Hint: Action can be created with `CallbackAction`, name of the intent will be `SelectLetterIntent`. Function to be called will be named as `_selectMovingElement`.

After you created everything, it is time to build the elements that run your gaming mechanism.

```dart
class _GameState extends State<Game> {
  ...
  int _movingIndex = -1;

  ...

  void _selectMovingElement() {
    if (_resultFocusNode.hasFocus && _movingIndex != -1) {
      _updateItem(letters[_movingIndex], _selectedIndex);
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
}
```

`_movingIndex` keeps a reference to the element to be moved. The code tries to move the element if the cursor is above and with a selected letter.

If you five letters to the system, you should be seeing either success or failure message via a dialog.

![Step 7 Result](https://raw.githubusercontent.com/salihgueler/keyboard_puzzle_dartpad_workshop/main/step_07/output.gif)

> 📝 Last homework! Add a keyboard shortcut to control the behavior of the dialog with the knowledge you had!
