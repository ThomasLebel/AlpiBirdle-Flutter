import 'dart:math';

import 'package:birdle/game.dart';
import 'package:birdle/widgets/guess_input.dart';
import 'package:birdle/widgets/tile.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();
  late final ConfettiController _confettiController;

  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
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
                  print(_game.hiddenWord);
                  if (_game.guessesRemaining == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Le jeu est terminé ! Appuyez sur le bouton de redémarrage pour jouer à nouveau.",
                        ),
                      ),
                    );
                    return;
                  }
                  if (guess.length != 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "La proposition doit contenir 5 lettres !",
                        ),
                      ),
                    );
                    return;
                  }
                  if (guess.contains(" ")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "La proposition ne peut pas contenir d'espaces !",
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _game.guess(guess);
                  });

                  if (_game.didLose) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("😭 Perdu ! 😭"),
                        content: Text(
                          "Le mot était ${_game.hiddenWord.toString().toUpperCase()}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else if (_game.didWin) {
                    _confettiController.play();
                  }
                },
                onResetGame: () {
                  _confettiController.stop();
                  setState(() {
                    _game.resetGame();
                  });
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 12,
            emissionFrequency: 0.1,
            gravity: 0.2,
            colors: [
              Colors.green,
              Colors.yellow,
              Colors.blue,
              Colors.pink,
              Colors.orange,
            ],
          ),
        ),
      ],
    );
  }
}
