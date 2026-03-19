import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.quiz, color: Colors.blueGrey),
                ),
              ),
              Align(alignment: Alignment.centerLeft, child: Text("Birdle")),
            ],
          ),
        ),
        body: Center(child: Column(children: [GamePage()])),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(
    this.letter,
    this.hitType, {
    super.key,
    this.delay = Duration.zero,
  });

  final String letter;
  final HitType hitType;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    if (hitType == HitType.none || hitType == HitType.removed) {
      return container;
    }

    return container.animate().flipH(duration: 600.ms, delay: delay);
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var (index, letter) in guess.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2.5,
                      vertical: 2.5,
                    ),
                    child: Tile(
                      letter.char,
                      letter.type,
                      delay: Duration(milliseconds: index * 150),
                    ),
                  ),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              if (guess.length != 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Guess must be 5 letters long!")),
                );
                return;
              }
              if (guess.contains(" ")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Guess cannot contain spaces!")),
                );
                return;
              }
              setState(() {
                _game.guess(guess);
              });
            },
            onResetGame: () {
              setState(() {
                _game.resetGame();
              });
            },
          ),
        ],
      ),
    );
  }
}

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
        Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            iconSize: 48,
            onPressed: () {
              widget.onResetGame();
              _textEditingController.clear();
            },
            icon: Icon(Icons.restart_alt, color: Colors.blueGrey),
            padding: EdgeInsets.zero,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: _focusNode,
                    maxLength: 5,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
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
                  icon: Icon(Icons.arrow_circle_up),
                  padding: EdgeInsets.zero,
                  hoverColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
