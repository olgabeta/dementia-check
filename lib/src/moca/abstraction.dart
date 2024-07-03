import 'package:flutter/material.dart';
import 'recall.dart';
import 'diacritics.dart';
import 'score_manager.dart';

class AbstractionGame extends StatelessWidget {
  const AbstractionGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AbstractionScreen(),
    );
  }
}

class AbstractionScreen extends StatefulWidget {
  const AbstractionScreen({super.key});

  @override
  _AbstractionScreenState createState() => _AbstractionScreenState();
}

class _AbstractionScreenState extends State<AbstractionScreen> {

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  final Map<int, List<String>> _correctAnswers = {
    1: ['μεσα μεταφορας', 'μεσα μεταφορασ', 'μεταφορικα μεσα', 'μεσα ταξιδιου', 'πραγματοποιεις εκδρομες και με τα δυο', 'πραγματοποιεισ εκδρομεσ και με τα δυο'],
    2: ['οργανα μετρησης', 'οργανα μετρησησ', 'εργαλεια μετρησης', 'εργαλεια μετρησησ', 'χρησιμοποιουνται για να μετρησουμε']
  };

  final String gameName = 'Ομοιότητα';
  int _score = 0;

  // Normalize Unicode and remove spaces
  String _normalizeText(String text) {
    String normalText = removeDiacritics(text);
    return normalText.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  void _checkAnswers() {
    // Retrieve and normalize user inputs
    String answer1 = _normalizeText(_controller1.text);
    String answer2 = _normalizeText(_controller2.text);

    // Compare normalized answers with normalized correct answers
    if (_correctAnswers[1]!.map(_normalizeText).contains(answer1)) _score++;
    if (_correctAnswers[2]!.map(_normalizeText).contains(answer2)) _score++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('11. Αφηρημένη σκέψη'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Για κάθε ζευγάρι λέξεων, γράψτε σε ποια κατηγορία ανήκουν. Το πρώτο ζευγάρι αποτελεί παράδειγμα.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'μπανάνα - πορτοκάλι',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'τρένο - ποδήλατο',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ρολόι - χάρακας',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'φρούτα',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller1,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Γράψτε εδώ',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Γράψτε εδώ',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _checkAnswers();
                // Pass the score and navigate to next game screen
                ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecallScreen()),
                );
              },
              child: const Text('Επόμενο', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}