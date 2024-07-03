import 'package:flutter/material.dart';
import 'dart:async';
import 'score_manager.dart';
import 'subtraction.dart';

class LetterList extends StatelessWidget {
  const LetterList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LetterListScreen(),
    );
  }
}

class LetterListScreen extends StatefulWidget {
  const LetterListScreen({super.key});

  @override
  _LetterListScreenState createState() => _LetterListScreenState();
}

class _LetterListScreenState extends State<LetterListScreen> {

  final String gameName = 'Εντοπισμός γραμμάτων';
  int _score = 0;

  List<String> letters = "	ΦBAΓMNAAΞKΛBAΦAKΔEAAAΞAMOΦAAB.".split('');
  List<String> displayedLetters = [];
  int currentLetterIndex = 0;
  bool gameStarted = false;
  bool missedLetter = false;

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      missedLetter = false;
    });
    showNextLetter();
  }

  void showNextLetter() {
    if (currentLetterIndex < letters.length) {
      Timer(const Duration(seconds: 1), () {
        setState(() {
          displayedLetters.add(letters[currentLetterIndex]);
          if (letters[currentLetterIndex] == 'A' && !missedLetter) {
            missedLetter = true;
          }
          currentLetterIndex++;
        });
        showNextLetter();
      });
    } else {
      // Game over
      setState(() {
        gameStarted = false;
        if (!missedLetter || _score == 0) {
          _score = 1;
        } else {
          _score = 0;
        }
      });
      // Navigate to next game screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubtractionScreen()),
      );
    }
    // Pass the score
    ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
  }

  void _onTapLetterA() {
    if (letters[currentLetterIndex] == 'Α') {
      setState(() {
        if (displayedLetters.indexOf('A') <= 1) {
          _score++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7. Εντοπισμός γραμμάτων'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Θα εμφανιστεί μια σειρά γραμμάτων. Κάθε φορά που βλέπετε το γράµµα Α, πατήστε το κουμπί.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 50),
            if (!gameStarted)
                Center(
                  child: ElevatedButton(
                    onPressed: startGame,
                    child: const Text('Ξεκινήστε'),
                  ),
                ),
            if (gameStarted)
              Text(
                displayedLetters.join('  '),
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 50),
            if (gameStarted)
              Center(
                child: ElevatedButton(
                  onPressed: _onTapLetterA,
                  child: Text(
                    'Πατήστε εδώ',
                    style: TextStyle(color: Colors.purple[400]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}