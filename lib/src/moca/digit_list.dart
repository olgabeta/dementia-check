import 'package:flutter/material.dart';
import 'dart:async';
import 'score_manager.dart';
import 'letter_list.dart';

class DigitList extends StatelessWidget {
  const DigitList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DigitListScreen(),
    );
  }
}

class DigitListScreen extends StatefulWidget {
  const DigitListScreen({super.key});

  @override
  _DigitListScreenState createState() => _DigitListScreenState();
}

class _DigitListScreenState extends State<DigitListScreen> {

  final String gameName = 'Ανάκληση ψηφίων';
  int _score = 0;

  int currentStep = 0;
  List<String> instruction = [
    "Διαβάστε τους παρακάτω αριθµούς με τη σειρά και γράψτε τους ακριβώς όπως τους διαβάσατε, χωρίς κόμματα.",
    "Τώρα διαβάστε µερικούς ακόµη αριθµούς, αλλά γράψτε τους µε την αντίστροφη σειρά χωρίς κόμματα."
  ];
  List<String> numbers = ['2 1 8 5 4', '7 4 2'];
  List<List<String>> acceptableAnswers = [
    ['21854', '21854 ', '2 1 8 5 4', '2 1 8 5 4 '],
    ['247', '247 ', '2 4 7', '2 4 7 '],
  ];
  String displayedNumbers = "";
  bool numbersVisible = true;
  String userInput = "";

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    displayedNumbers = numbers[currentStep];
    Future.delayed(const Duration(seconds: 14), () {
      setState(() {
        numbersVisible = false;
      });
    });
  }

  void nextStep() {
    setState(() {
      if (userInput.isNotEmpty && acceptableAnswers[currentStep].contains(userInput)) {
        _score++;
      }
      currentStep++;
      if (currentStep < numbers.length) {
        displayedNumbers = numbers[currentStep];
        numbersVisible = true;
        userInput = "";
        Future.delayed(const Duration(seconds: 12), () {
          setState(() {
            numbersVisible = false;
          });
        });
      } else {
        // Pass the score and navigate to next game screen
        ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LetterListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6. Ανάκληση ψηφίων'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentStep < instruction.length ? instruction[currentStep] : "",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                numbersVisible ? displayedNumbers : "",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (!numbersVisible)
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    userInput = value;
                  });
                },
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  labelText: 'Γράψτε τους αριθμούς χωρίς κενά',
                  labelStyle: TextStyle(color: Colors.black54),
                ),
              ),
            const SizedBox(height: 50),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: numbersVisible ? null : nextStep,
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