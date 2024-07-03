import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'score_manager.dart';
import 'abstraction.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LanguageScreen(),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  final String gameName = 'Γλωσσική ροή';
  int _score = 0;

  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _start = 90;
  bool _gameOver = false;
  bool _gameOn = false;
  final String initialLetter = 'φ';
  Set<String> dictionary = {};

  @override
  void initState() {
    super.initState();
    loadDictionary();
  }

  Future<void> loadDictionary() async {
    final String dictionaryData = await rootBundle.loadString('assets/dictionary.txt');
    setState(() {
      dictionary = dictionaryData.split('\n').map((word) => word.trim()).toSet();
    });
  }

  void startTimer() {
    _start = 60;
    _gameOver = false;
    _gameOn = true;
    setState(() {});

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _gameOver = true;
          _gameOn = false;
          // Navigate to next game screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AbstractionScreen())
          );
        });
        _timer?.cancel();
        _validateWords();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _validateWords() {
    final words = _controller.text.split(' ');
    int correctWords = 0;

    for (String word in words) {
      word = word.trim();
      if (word.startsWith(initialLetter) && dictionary.contains(word)) {
        correctWords++;
      }
    }

    setState(() {
      _score = correctWords >= 11 ? 1 : 0;
      ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('10. Γλωσσική ροή'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_gameOver && !_gameOn)
              Text(
                'Γράψτε όσες περισσότερες λέξεις µπορείτε να σκεφτείτε που να ξεκινούν µε το γράµµα "$initialLetter", με κενό μεταξύ τους. Απαγορεύονται τα ονόματα, οι αριθμοί και διαφορετικές μορφές του ίδιου ρήματος. Έχετε 1 λεπτό.',
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(height: 40),
            if (!_gameOver && _gameOn)
              Column(
                children: [
                  Text(
                    'Απομένουν $_start δευτερόλεπτα.',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    readOnly: _gameOver,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      labelText: 'Γράψτε εδώ',
                      labelStyle: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            if (!_gameOver && !_gameOn)
              Center(
                child: ElevatedButton(
                  onPressed: startTimer,
                  child: Text(
                    'Ξεκινήστε',
                    style: TextStyle(color: Colors.indigo[400]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}