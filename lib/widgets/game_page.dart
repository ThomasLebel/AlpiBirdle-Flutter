import 'package:audioplayers/audioplayers.dart';
import 'package:birdle/game.dart';
import 'package:birdle/widgets/guess_input.dart';
import 'package:birdle/widgets/tile.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Game _game = Game();
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _audioPlayer.setVolume(0);
    _audioPlayer.play(AssetSource('sounds/win.wav')).then((_) {
      _audioPlayer.play(AssetSource('sounds/fail.wav')).then((_) {
        _audioPlayer.stop();
        _audioPlayer.setVolume(1);
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onWin() {
    _audioPlayer.play(AssetSource('sounds/win.wav'));
    _confettiController.play();
  }

  void _onLose() {
    _audioPlayer.play(AssetSource('sounds/fail.wav'));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("😭 Perdu ! 😭"),
        content: Text(
          "Le mot était ${_game.hiddenWord.toString().toUpperCase()}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onSubmitGuess(String guess) {
    print(_game.hiddenWord);

    if (_game.didWin || _game.didLose) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Le jeu est terminé ! Appuyez sur le bouton de redémarrage pour jouer à nouveau.",
          ),
        ),
      );
      return;
    }
    if (guess.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La proposition doit contenir 5 lettres !"),
        ),
      );
      return;
    }
    if (guess.contains(" ")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La proposition ne peut pas contenir d'espaces !"),
        ),
      );
      return;
    }

    setState(() => _game.guess(guess));

    if (_game.didLose)
      _onLose();
    else if (_game.didWin)
      _onWin();
  }

  void _onResetGame() {
    _confettiController.stop();
    setState(() => _game.resetGame());
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
              for (var (guessIndex, guess) in _game.guesses.indexed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var (letterIndex, letter) in guess.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.5,
                          vertical: 2.5,
                        ),
                        child: Tile(
                          letter.char,
                          letter.type,
                          delay: Duration(milliseconds: letterIndex * 150),
                        ),
                      ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ColorHint(color: Colors.green, label: "Bonne place"),
                    SizedBox(width: 12),
                    _ColorHint(color: Colors.yellow, label: "Mal placée"),
                    SizedBox(width: 12),
                    _ColorHint(color: Colors.grey, label: "Absente"),
                  ],
                ),
              ),
              GuessInput(
                onSubmitGuess: _onSubmitGuess,
                onResetGame: _onResetGame,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 20, // plus par burst
            emissionFrequency: 0.05, // moins fréquent
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.3,
            shouldLoop: false,
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

class _ColorHint extends StatelessWidget {
  const _ColorHint({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
