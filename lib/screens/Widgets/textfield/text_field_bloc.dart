import 'dart:async';

class TextFieldBloc {
  final _focusController = StreamController<bool>.broadcast();
  Stream<bool> get focusStream => _focusController.stream;

  void dispose() {
    _focusController.close();
  }

  void setFocus(bool isFocused) {
    _focusController.add(isFocused);
  }
}

final textFieldBloc = TextFieldBloc();
