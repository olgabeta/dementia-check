import 'package:flutter/material.dart';
import 'memory.dart';
import 'diacritics.dart';
import 'score_manager.dart';

class NamingGame extends StatelessWidget {
  const NamingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NamingScreen(),
    );
  }
}

class NamingScreen extends StatefulWidget {
  const NamingScreen({super.key});

  @override
  _NamingScreenState createState() => _NamingScreenState();
}

class _NamingScreenState extends State<NamingScreen> {

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  final Map<int, List<String>> _correctAnswers = {
    1: ['λιονταρι'],
    2: ['ρινοκερος', 'ρινοκεροσ'],
    3: ['καμηλα', 'δρομαδα']
  };

  final String gameName = 'Κατονομασία';
  int _score = 0;

  // Normalize Unicode and remove spaces
  String _normalizeText(String text) {
    String normalText = removeDiacritics(text);
    return normalText.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  void _checkAnswers() {
    String answer1 = _normalizeText(_controller1.text);
    String answer2 = _normalizeText(_controller2.text);
    String answer3 = _normalizeText(_controller3.text);

    if (_correctAnswers[1]!.contains(answer1)) _score++;
    if (_correctAnswers[2]!.contains(answer2)) _score++;
    if (_correctAnswers[3]!.contains(answer3)) _score++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4. Κατονομασία'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Γράψτε το όνομα του κάθε ζώου δίπλα στη φωτογραφία του.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/lion.png',
                        width: 150,
                      ),
                      Image.asset(
                        'assets/rhino.png',
                        width: 150,
                      ),
                      Image.asset(
                        'assets/camel.png',
                        width: 150,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller1,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '1ο ζώο',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '2ο ζώο',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller3,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '3ο ζώο',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Row(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _checkAnswers();
                // Pass the score and navigate to next game screen
                ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemoryScreen()),
                );
              },
              child: const Text('Επόμενο', textAlign: TextAlign.center)
            ),
          ),
        ],
      ),
    );
  }
}