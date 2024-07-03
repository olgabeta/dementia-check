import 'package:flutter/material.dart';
import 'orientation.dart';
import 'score_manager.dart';

class RecallGame extends StatelessWidget {
  const RecallGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecallScreen(),
    );
  }
}

class RecallScreen extends StatefulWidget {
  const RecallScreen({super.key});

  @override
  _RecallScreenState createState() => _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {

  final String gameName = 'Καθυστερημένη ανάκληση';
  int _score = 0;

  final TextEditingController _controller = TextEditingController();
  final List<List<String>> _words = [
    ['πρόσωπο', 'προσωπο'],
    ['βελούδο', 'βελουδο'],
    ['εκκλησία', 'εκκλησια'],
    ['μαργαρίτα', 'μαργαριτα'],
    ['κόκκινο', 'κοκκινο']
  ];

  void _checkAnswers() {
    List<String> userWords = _controller.text.split(' ').map((word) => word.toLowerCase()).toList();
    setState(() {
      _score = userWords.where((userWord) => _words.any((wordList) => wordList.contains(userWord))).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('12. Καθυστερημένη ανάκληση'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Διαβάσατε μια λίστα λέξεων νωρίτερα, τις οποίες σας ζητήθηκε να θυµηθείτε. Γράψτε όσες περισσότερες από αυτές τις λέξεις µπορείτε να θυµηθείτε, με κενά μεταξύ τους.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Γράψτε τις λέξεις εδώ',
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _checkAnswers();
                // Pass the score and navigate to next screen
                ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrientationScreen()),
                );
              },
              child: const Text('Επόμενο', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
