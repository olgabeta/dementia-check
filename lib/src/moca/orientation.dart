import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'diacritics.dart';
import 'score_manager.dart';
import 'score.dart';

class OrientationGame extends StatelessWidget {
  const OrientationGame({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrientationScreen(),
    );
  }
}

class OrientationScreen extends StatefulWidget {
  const OrientationScreen({super.key});

  @override
  _OrientationScreenState createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {

  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weekdayController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  final String gameName = 'Προσανατολισμός';
  int _score = 0;
  final String _currentCountry = 'Ελλάδα';
  String _currentPostalCode = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Οι υπηρεσίες τοποθεσίας είναι απενεργοποιημένες.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Οι άδειες τοποθεσίας απορρίφθηκαν.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Οι άδειες τοποθεσίας απορρίφθηκαν μόνιμα, δεν μπορούμε να ζητήσουμε άδεια.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentPostalCode = place.postalCode ?? '';
      });
    } catch (e) {
      return;
    }
  }

  // Normalize Unicode and remove spaces
  String _normalizeText(String text) {
    String normalText = removeDiacritics(text);
    return normalText.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  void _checkAnswers() {
    DateTime now = DateTime.now();
    String currentYear = DateFormat('yyyy', 'el').format(now);
    String currentMonth = DateFormat('MMMM', 'el').format(now);
    String currentWeekday = DateFormat('EEEE', 'el').format(now);

    // Normalize values to ignore accents and spaces
    String expectedMonth = _normalizeText(currentMonth);
    String expectedWeekday = _normalizeText(currentWeekday);
    String expectedCountry = _normalizeText(_currentCountry);
    String expectedPostalCode = _normalizeText(_currentPostalCode);

    String userMonth = _normalizeText(_monthController.text);
    String userWeekday = _normalizeText(_weekdayController.text);
    String userCountry = _normalizeText(_countryController.text);
    String userPostalCode = _normalizeText(_postalCodeController.text);

    // Compare and update score
    setState(() {
      if (_yearController.text.isNotEmpty && _yearController.text == currentYear) _score++;
      if (_monthController.text.isNotEmpty && userMonth == expectedMonth) _score++;
      if (_dateController.text.isNotEmpty && _dateController.text == DateFormat('dd/MM/yyyy').format(now)) _score++;
      if (_weekdayController.text.isNotEmpty && userWeekday == expectedWeekday) _score++;
      if (_countryController.text.isNotEmpty && userCountry == expectedCountry) _score++;
      if (_postalCodeController.text.isNotEmpty && userPostalCode == expectedPostalCode) _score++;
    });
  }

  Future<void> _showEducationDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Σχεδόν τελειώσατε...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: const Text("Πόσα χρόνια επίσημης εκπαίδευσης έχετε, ξεκινώντας μετά το νηπιαγωγείο;",
              style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _score++;
                Navigator.of(context).pop();
              },
              child: const Text("12 χρόνια ή λιγότερα",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Περισσότερα από 12 χρόνια",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('13. Προσανατολισμός'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Γράψτε τη σημερινή ημερομηνία, τη χώρα όπου ζείτε και τον ταχυδρομικό κώδικα της περιοχής σας όπου βρίσκεστε.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Ακριβής ημερομηνία (ΗΗ/ΜΜ/ΕΕΕΕ)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Τρέχον έτος'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _monthController,
              decoration: const InputDecoration(labelText: 'Τρέχων μήνας (στη γενική πτώση)'),
            ),
            TextField(
              controller: _weekdayController,
              decoration: const InputDecoration(labelText: 'Τρέχουσα ημέρα της εβδομάδας'),
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Χώρα όπου βρίσκεστε'),
            ),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Ταχυδρομικός κώδικας της περιοχής σας'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 50),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _showEducationDialog();
                    _checkAnswers();
                    // Pass the score and navigate to score screen
                    ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScoreScreen(),
                      ),
                    );
                  },
                  child: const Text('Επόμενο', textAlign: TextAlign.center)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}