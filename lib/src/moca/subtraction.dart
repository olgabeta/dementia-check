import 'package:flutter/material.dart';
import 'score_manager.dart';
import 'repetition.dart';

class Subtraction extends StatelessWidget {
  const Subtraction({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SubtractionScreen(),
    );
  }
}

class SubtractionScreen extends StatefulWidget {
  const SubtractionScreen({super.key});

  @override
  _SubtractionScreenState createState() => _SubtractionScreenState();
}

class _SubtractionScreenState extends State<SubtractionScreen> {

  final String gameName = 'Διαδοχική αφαίρεση';
  int _score = 0;

  final int initialNumber = 100;
  final int subtractionValue = 7;
  final int numberOfSubtractions = 5;
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfSubtractions; i++) {
      controllers.add(TextEditingController());
    }
  }

  void calculateScore() {
    int correctAnswers = 0;
    int previousValue = initialNumber;

    for (int i = 0; i < numberOfSubtractions; i++) {
      int userValue = int.tryParse(controllers[i].text) ?? -1;

      if (userValue == previousValue - subtractionValue) {
        correctAnswers++;
      }
      previousValue = userValue;
    }

    if (correctAnswers >= 4) {
      _score = 3;
    } else if (correctAnswers >= 2) {
      _score = 2;
    } else if (correctAnswers >= 1) {
      _score = 1;
    } else {
      _score = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8. Διαδοχική αφαίρεση'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Αφαιρέστε 7 από το 100 και συνεχίστε να αφαιρείτε 7 από την απάντησή σας. Γράψτε το κάθε αποτέλεσμα στο αντίστοιχο πεδίο.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            Text(
              '$initialNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < numberOfSubtractions; i++) ...[
              Center(
                child: SizedBox(
                  width: 200,
                  child: Card(
                    child: TextField(
                      controller: controllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: '${i + 1}η αφαίρεση',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    calculateScore();
                    // Pass the score and navigate to next game screen
                    ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RepetitionScreen()),
                    );
                  },
                  child: const Text('Επόμενο', textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}