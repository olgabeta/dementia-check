import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:string_similarity/string_similarity.dart';
import 'diacritics.dart';
import 'score_manager.dart';
import 'language.dart';

class Repetition extends StatelessWidget {
  const Repetition({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RepetitionScreen(),
    );
  }
}

class RepetitionScreen extends StatefulWidget {
  const RepetitionScreen({super.key});

  @override
  _RepetitionScreenState createState() => _RepetitionScreenState();
}

class _RepetitionScreenState extends State<RepetitionScreen> {

  final String gameName = 'Επανάληψη';
  int _score = 0;

  List<String> sentences = [
    "Το µόνο που ξέρω είναι ότι ο Γιάννης είναι αυτός που θα βοηθήσει σήµερα",
    "Η γάτα πάντα κρυβόταν κάτω από τον καναπέ όταν σκυλιά βρισκόταν µέσα στο δωµάτιο",
  ];
  String currentSentence = "";
  int currentSentenceIndex = -1;
  String userSpeech = "";
  bool isListening = false;
  bool sentenceVisible = true;
  bool showStartButton = true;
  bool processingInput = false;
  stt.SpeechToText speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  void startGame() {
    setState(() {
      currentSentenceIndex = 0;
      _score = 0;
      showStartButton = false;
      showSentence();
    });
  }

  void showSentence() {
    setState(() {
      sentenceVisible = true;
      currentSentence = sentences[currentSentenceIndex];
      userSpeech = "";
      Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          sentenceVisible = false;
        });
      });
    });
  }

  void startListening() async {
    if (processingInput) return;

    bool available = await speech.initialize(
      onStatus: (val) {
        if (val == 'done') {
          stopListening();
        }
      },
    );

    if (available) {
      setState(() {
        isListening = true;
        userSpeech = "";
      });

      speech.listen(
        onResult: (val) {
          setState(() {
            userSpeech = val.recognizedWords;
            if (val.finalResult) {
              stopListening();
            }
          });
        },
        localeId: 'el_GR',  // Greek locale
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  void compareSentences() {
    if (processingInput) return;
    processingInput = true;

    String normalizedUserSpeech = _normalizeText(userSpeech);
    String normalizedCurrentSentence = _normalizeText(currentSentence);

    double similarityScore = normalizedUserSpeech.similarityTo(normalizedCurrentSentence) * 100;

    if (similarityScore > 90) {
      setState(() {
        _score++;
      });
    }
    processingInput = false;
  }

  String _normalizeText(String text) {
    return removeDiacritics(text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ''));
  }

  void nextSentence() {
    if (isListening) {
      stopListening();
    }

    compareSentences(); // Compare sentences before moving to the next one

    if (currentSentenceIndex < sentences.length - 1) {
      setState(() {
        currentSentenceIndex++;
        showSentence();
      });
    } else {
      ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LanguageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('9. Επανάληψη'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Διαβάστε την πρόταση και, στη συνέχεια, επαναλάβετε τη ακριβώς όπως τη διαβάσατε, αφού πατήσετε το κουμπί του μικροφώνου. Μπορείτε να ηχογραφήσετε όσες προσπάθειες θέλετε προτού προχωρήσετε.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            if (sentenceVisible)
              Text(
                currentSentence,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            if (!sentenceVisible)
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: startListening,
                      child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 30),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Είπατε: "$userSpeech"',
                      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: nextSentence,
                      child: const Text('Επόμενο', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            if (showStartButton)
              Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  child: Text(
                    'Ξεκινήστε',
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
