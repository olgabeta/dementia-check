import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dementia_check/src/scd/chatbot.dart';
import 'package:dementia_check/src/moca/connect_dots.dart';
import 'package:dementia_check/src/moca/score_manager.dart';

void main() {
  initializeDateFormatting('el_GR', null).then((_) {
    runApp(const App());
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late LifecycleReactor _lifecycleReactor;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _lifecycleReactor = LifecycleReactor(onAppResume: _restartApp);
  }

  @override
  void dispose() {
    _lifecycleReactor.dispose();
    super.dispose();
  }

  void _restartApp() {
    // Reset the scores
    ScoreManager().resetScores();
    // Restart the app
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        appBarTheme: const AppBarTheme(
          color: Colors.grey,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            shadowColor: Colors.grey,
            backgroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[800]),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dementia Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Display the app logo
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Image.asset('assets/logo.png',
                width: 220,
                height: 220,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to chatbot screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chatbot()),
                );
              },
              child: Text('Γρήγορος νοητικός έλεγχος',
                  style: TextStyle(color: Colors.indigo[400], fontSize: 22),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to MoCA screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConnectTheDots()),
                );
              },
              child: Text('Γνωστική αξιολόγηση: MoCA',
                style: TextStyle(color: Colors.cyan[800], fontSize: 22),
                textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class LifecycleReactor with WidgetsBindingObserver {
  final VoidCallback onAppResume;

  LifecycleReactor({required this.onAppResume}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onAppResume(); // Restart the app when it is resumed
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}