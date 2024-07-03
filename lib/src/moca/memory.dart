import 'package:flutter/material.dart';
import 'dart:async';
import 'digit_list.dart';

class MemoryGame extends StatelessWidget {
  const MemoryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MemoryScreen(),
    );
  }
}

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {

  final List<String> _words = ['ΠΡΟΣΩΠΟ', 'ΒΕΛΟΥΔΟ', 'ΕΚΚΛΗΣΙΑ', 'ΜΑΡΓΑΡΙΤΑ', 'ΚΟΚΚΙΝΟ'];
  bool _showWords = false;
  bool _isShowWordsButtonEnabled = true;
  String _instructions = 'Πατήστε το παρακάτω κουμπί για να εμφανιστεί η λίστα λέξεων που θα πρέπει να θυµηθείτε τώρα και αργότερα. Διαβάστε προσεκτικά.';
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _step = 0;

  void _showWordsForDuration() {
    setState(() {
      _showWords = true;
      _isShowWordsButtonEnabled = false; // Disable the button
    });

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 6), () {
      setState(() {
        _showWords = false;
        _updateInstructions();
      });
    });
  }

  void _updateInstructions() {
    setState(() {
      if (_step == 0) {
        _instructions = 'Γράψτε παρακάτω όσες περισσότερες λέξεις µπορείτε να θυµηθείτε. Δεν έχει σηµασία µε ποια σειρά τις γράφετε.';
        _step++;
      } else if (_step == 1) {
        _instructions = 'Διαβάστε τη λίστα λέξεων ξανά.';
        _controller.clear();
        _step++;
      } else if (_step == 2) {
        _instructions = 'Προσπαθήστε να θυµηθείτε και να γράψετε όσες περισσότερες λέξεις µπορείτε, συµπεριλαµβανοµένων των λέξεων που γράψατε την πρώτη φορά.';
        _step++;
      } else if (_step == 3) {
        _instructions =
        'Θα σας ζητηθεί να ανακαλέσετε ξανά αυτές τις λέξεις στο τέλος του τεστ.';

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DigitListScreen()),
        );
      }
    });
  }

  void _handleSubmit() {
    setState(() {
      _controller.clear();
      _updateInstructions();
      _isShowWordsButtonEnabled = true; // Re-enable the button after submit
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5. Μνήμη'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Text(
              _instructions,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            _showWords
                ? Column(
              children: _words.map((word) => Text(word, style: const TextStyle(fontSize: 26))).toList(),
            )
                : Container(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isShowWordsButtonEnabled ? _showWordsForDuration : null,
                child: Text(
                  'Δείτε τις λέξεις',
                  style: TextStyle(color: Colors.purple[400]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                labelText: 'Γράψτε τις λέξεις εδώ',
                labelStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Επόμενο', textAlign: TextAlign.center)
              ),
            ),
          ],
        ),
      ),
    );
  }

}