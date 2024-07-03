import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'score_manager.dart';
import 'package:dementia_check/main.dart';

class ScoreResults extends StatelessWidget {
  const ScoreResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScoreScreen(),
    );
  }
}

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {

  @override
  Widget build(BuildContext context) {
    final scores = ScoreManager().scores;

    // Define categories
    final Map<String, String> categoryMap = {
      'Ένωσε τις τελείες': 'Οπτικοχωρικές/Εκτελεστικές',
      'Αντιγραφή κύβου': 'Οπτικοχωρικές/Εκτελεστικές',
      'Σχεδιασμός πίτσας': 'Οπτικοχωρικές/Εκτελεστικές',
      'Κατονομασία': 'Κατονομασία',
      'Ανάκληση ψηφίων': 'Προσοχή',
      'Εντοπισμός γραμμάτων': 'Προσοχή',
      'Διαδοχική αφαίρεση': 'Προσοχή',
      'Επανάληψη': 'Γλώσσα',
      'Γλωσσική ροή': 'Γλώσσα',
      'Ομοιότητα': 'Αφηρημένη σκέψη',
      'Καθυστερημένη ανάκληση': 'Ανάκληση',
      'Προσανατολισμός': 'Προσανατολισμός',
    };

    final Map<String, int> maxScores = {
      'Οπτικοχωρικές/Εκτελεστικές': 5,
      'Κατονομασία': 3,
      'Προσοχή': 6,
      'Γλώσσα': 3,
      'Αφηρημένη σκέψη': 2,
      'Ανάκληση': 5,
      'Προσανατολισμός': 6,
    };

    final Map<String, Color> categoryColors = {
      'Οπτικοχωρικές/Εκτελεστικές': Colors.lightGreen,
      'Κατονομασία': Colors.teal,
      'Προσοχή': Colors.cyan,
      'Γλώσσα': Colors.blue,
      'Αφηρημένη σκέψη': Colors.indigo,
      'Ανάκληση': Colors.purple,
      'Προσανατολισμός': Colors.pinkAccent,
    };

    // Group scores by categories
    final Map<String, double> categoryScores = {};

    for (var score in scores) {
      String category = categoryMap[score.gameName] ?? 'Άλλο';
      if (categoryScores.containsKey(category)) {
        categoryScores[category] = categoryScores[category]! + score.score.toDouble();
      } else {
        categoryScores[category] = score.score.toDouble();
      }
    }

    final List<GameScore> categoryScoreList = categoryScores.entries.map((entry) {
      int maxScore = maxScores[entry.key] ?? 1;
      double normalizedScore = (entry.value / maxScore) * 100;
      return GameScore(gameName: entry.key, score: normalizedScore.toInt());
    }).toList();

    // Calculate the total score
    final int totalScore = categoryScores.entries.fold(0, (sum, item) => sum + item.value.toInt());

    // Determine the score category
    String scoreCategory;
    if (totalScore >= 26) {
      scoreCategory = "Φυσιολογική γνωστική λειτουργία";
    } else if (totalScore >= 18) {
      scoreCategory = "Ήπια γνωστική εξασθένηση";
    } else if (totalScore >= 10) {
      scoreCategory = "Μέτρια γνωστική εξασθένηση";
    } else {
      scoreCategory = "Σοβαρή γνωστική εξασθένηση";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Αποτελέσματα', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Συνολική βαθμολογία: $totalScore/30',
              style: TextStyle(color: Colors.indigo[400], fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              scoreCategory,
              style: TextStyle(color: Colors.indigo[400], fontSize: 22),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SfCircularChart(
                title: const ChartTitle(
                    text: 'Αναλυτική βαθμολογία:',
                    textStyle: TextStyle(fontSize: 16)),
                legend: const Legend(isVisible: false),
                series: <CircularSeries>[
                  RadialBarSeries<GameScore, String>(
                    radius: '90%',
                    innerRadius: '20%',
                    gap: '3%',
                    dataSource: categoryScoreList,
                    xValueMapper: (GameScore data, _) => data.gameName,
                    yValueMapper: (GameScore data, _) => data.score,
                    pointColorMapper: (GameScore data, _) {
                      String category = data.gameName;
                      return categoryColors[category] ?? Colors.grey;
                    },
                    cornerStyle: CornerStyle.bothCurve,
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                    maximumValue: 100,
                  ),
                ],
              ),
            ),
            Column(
              children: categoryScoreList.map((score) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      color: categoryColors[score.gameName] ?? Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${score.gameName}: ${score.score.toInt()}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Επόμενο', textAlign: TextAlign.center)
              ),
            ),
          ]
        ),
      ),
    );
  }
}