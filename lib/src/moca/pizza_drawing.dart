import 'package:flutter/material.dart';
import 'dart:math';
import 'score_manager.dart';
import 'naming.dart';

class PizzaDrawingGame extends StatelessWidget {
  const PizzaDrawingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PizzaDrawingScreen(),
    );
  }
}

class PizzaDrawingScreen extends StatefulWidget {
  const PizzaDrawingScreen({super.key});

  @override
  _PizzaDrawingScreenState createState() => _PizzaDrawingScreenState();
}

class _PizzaDrawingScreenState extends State<PizzaDrawingScreen> {

  final String gameName = 'Σχεδιασμός πίτσας';
  int _score = 0;

  int sliceCount = 0;
  int targetSlices = 6;
  Offset center = Offset.zero;
  double radius = 0;

  @override
  void initState() {
    super.initState();
  }

  void addSlice() {
    setState(() {
      sliceCount++;
    });
  }

  void calculateScore() {
    if (sliceCount == targetSlices) {
      _score = 3;
    } else if (sliceCount < targetSlices && sliceCount > 2) {
      _score = 2;
    } else if (sliceCount > targetSlices && sliceCount < 2 * targetSlices) {
      _score = 1;
    } else {
      _score = 0;
    }
  }

  void resetGame() {
    setState(() {
      sliceCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3. Σχεδιασμός πίτσας'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Πατήστε μέσα στο σχήμα μέχρι να χωρίσετε τον κύκλο σε 6 ίσα κομμάτια.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: addSlice,
              child: Center(
                child: CustomPaint(
                  size: const Size(250,250),
                  painter: CirclePainter(sliceCount),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (sliceCount > 0) {
                        sliceCount--;
                      }
                    });
                  },
                  child: Text('Αναίρεση', style: TextStyle(color: Colors.pinkAccent[700])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    calculateScore();
                    // Pass the score and navigate to next game screen
                    ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NamingScreen()),
                    );
                  },
                  child: const Text('Επόμενο', textAlign: TextAlign.center)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final int sliceCount;

  CirclePainter(this.sliceCount);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    canvas.drawCircle(center, radius, paint);

    if (sliceCount > 0) {
      double angle = 2 * pi / sliceCount;

      for (int i = 0; i < sliceCount; i++) {
        double x = center.dx + radius * cos(i * angle);
        double y = center.dy + radius * sin(i * angle);
        canvas.drawLine(center, Offset(x, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}