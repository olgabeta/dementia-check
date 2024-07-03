import 'package:flutter/material.dart';
import 'questions.dart';
import 'package:dementia_check/main.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatbotScreen(),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int _currentQuestionIndex = 0;
  final List<String> _messages = [];
  double _score = 0.0;

  final ScrollController _scrollController = ScrollController();



  void _sendQuestion() {
    int questionNumber = _currentQuestionIndex + 1; // Question numbers start from 1
    String questionText = questions[_currentQuestionIndex].questionText;
    String message = 'Ερώτηση $questionNumber: $questionText';
    setState(() {
      _messages.add(message);
    });
  }

  void _handleAnswer(String answer, int answerIndex) {
    setState(() {
      _messages.add('Απάντηση: $answer');

      // Update score based on the points assigned to the selected answer
      _score += questions[_currentQuestionIndex].optionPoints[answerIndex];
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _sendQuestion();

        //Scroll to the bottom after latest question
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      } else {
        _showFinalMessage();
      }
    });
  }

  void _showFinalMessage() {
    String finalMessage = _score < 3 ? 'Φυσιολογική γνωστική λειτουργία' : 'Πιθανή γνωστική εξασθένηση: Προτείνεται περαιτέρω εξέταση';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Αποτέλεσμα',
              style: TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline)),
          content: Text(finalMessage, style: const TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate back to home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                  'Κλείσιμο',
                  style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _sendQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot αυτοπαρατήρησης'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: _messages.length+1,
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return Container(height: 300);
                  }
                  bool isQuestion = _messages[index].startsWith('Ερώτηση:');
                  bool isAnswer = _messages[index].startsWith('Απάντηση:');
                  return Row(
                    mainAxisAlignment: isQuestion ? MainAxisAlignment.start : (isAnswer ? MainAxisAlignment.end : MainAxisAlignment.start),
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isQuestion ? Colors.black : (isAnswer ? Colors.green[400] : Colors.grey[800]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isQuestion ? Colors.black : (isAnswer ? Colors.green : Colors.grey),
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Text(
                          _messages[index],
                          style: TextStyle(
                            color: isQuestion ? Colors.white : (isAnswer ? Colors.white : Colors.white),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: questions[_currentQuestionIndex].options.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String option = entry.value;
                  return GestureDetector(
                    onTap: () => _handleAnswer(option, idx),
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}