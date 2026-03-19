import 'package:flutter/material.dart';

class GuessInput extends StatefulWidget {
  GuessInput({
    super.key,
    required this.onSubmitGuess,
    required this.onResetGame,
  });

  final void Function(String) onSubmitGuess;

  final void Function() onResetGame;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    widget.onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 225,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: _focusNode,
                    maxLength: 5,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: _textEditingController,
                    autofocus: true,
                    onSubmitted: (_) {
                      _onSubmit();
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: IconButton(
                  iconSize: 36,
                  onPressed: _onSubmit,
                  icon: Icon(Icons.arrow_circle_up, color: Colors.blueGrey),
                  padding: EdgeInsets.zero,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: IconButton(
                  iconSize: 36,
                  onPressed: () {
                    widget.onResetGame();
                    _textEditingController.clear();
                  },
                  icon: Icon(Icons.restart_alt, color: Colors.blueGrey),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
