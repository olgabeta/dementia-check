import 'package:flutter/material.dart';
import 'dart:math';
import 'copy_cube.dart';
import 'score_manager.dart';

class ConnectDotsGame extends StatelessWidget {
  const ConnectDotsGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConnectTheDots(),
    );
  }
}

class ConnectTheDots extends StatefulWidget {
  const ConnectTheDots({super.key});

  @override
  _ConnectTheDotsState createState() => _ConnectTheDotsState();
}

class _ConnectTheDotsState extends State<ConnectTheDots> {

  @override
  void initState() {
    super.initState();
  }

  final String gameName = 'Ένωσε τις τελείες';
  int _score = 0;

  List<Offset> points = [];
  final List<String> correctOrder = ['1', 'A', '2', 'B', '3', 'Γ', '4', 'Δ', '5', 'E'];

  Map<String, Offset> dotPositions = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calculateDotPositions();
  }

  void calculateDotPositions() {
    final Size screenSize = MediaQuery.of(context).size;
    dotPositions = {
      '1': Offset(screenSize.width * 0.4, screenSize.height * 0.25),
      'A': Offset(screenSize.width * 0.7, screenSize.height * 0.1),
      '2': Offset(screenSize.width * 0.85, screenSize.height * 0.2),
      'B': Offset(screenSize.width * 0.65, screenSize.height * 0.2),
      '3': Offset(screenSize.width * 0.8, screenSize.height * 0.45),
      'Γ': Offset(screenSize.width * 0.4, screenSize.height * 0.5),
      '4': Offset(screenSize.width * 0.5, screenSize.height * 0.4),
      'Δ': Offset(screenSize.width * 0.2, screenSize.height * 0.4),
      '5': Offset(screenSize.width * 0.15, screenSize.height * 0.2),
      'E': Offset(screenSize.width * 0.4, screenSize.height * 0.1),
    };
  }

  void _handleTap(String label) {
    setState(() {
      points.add(dotPositions[label]!);
    });
  }

  bool _isCorrectSequence() {
    if (points.length != correctOrder.length) {
      return false;
    }
    for (int i = 0; i < points.length; i++) {
      if (points[i] != dotPositions[correctOrder[i]]) {
        return false;
      }
    }
    return true;
  }

  bool _linesOverlap(Offset a1, Offset a2, Offset b1, Offset b2) {
    double crossProduct(Offset a, Offset b) {
      return a.dx * b.dy - a.dy * b.dx;
    }

    Offset subtract(Offset a, Offset b) {
      return Offset(a.dx - b.dx, a.dy - b.dy);
    }

    bool onSegment(Offset p, Offset q, Offset r) {
      return q.dx <= max(p.dx, r.dx) && q.dx >= min(p.dx, r.dx) &&
          q.dy <= max(p.dy, r.dy) && q.dy >= min(p.dy, r.dy);
    }

    double o1 = crossProduct(subtract(a2, a1), subtract(b1, a1));
    double o2 = crossProduct(subtract(a2, a1), subtract(b2, a1));
    double o3 = crossProduct(subtract(b2, b1), subtract(a1, b1));
    double o4 = crossProduct(subtract(b2, b1), subtract(a2, b1));

    if (o1 != 0 && o2 != 0 && o3 != 0 && o4 != 0) {
      return o1.sign != o2.sign && o3.sign != o4.sign;
    }

    return (o1 == 0 && onSegment(a1, b1, a2)) ||
        (o2 == 0 && onSegment(a1, b2, a2)) ||
        (o3 == 0 && onSegment(b1, a1, b2)) ||
        (o4 == 0 && onSegment(b1, a2, b2));
  }

  bool _checkForOverlappingLines() {
    for (int i = 0; i < points.length - 1; i++) {
      for (int j = i + 2; j < points.length - 1; j++) {
        if (_linesOverlap(points[i], points[i + 1], points[j], points[j + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  void calculateScore() {
    bool correctSequence = _isCorrectSequence();
    bool hasOverlappingLines = _checkForOverlappingLines();

    if (correctSequence && !hasOverlappingLines) {
      _score = 1;
    } else {
      _score = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1. Ένωσε τις τελείες'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Πατήστε πάνω στους κύκλους για να σχεδιαστεί µία γραµµή που να πηγαίνει από έναν αριθµό σε ένα γράµµα σε αύξουσα σειρά. Ξεκινήστε από το 1 και µετά πατήστε το Α, µετά το 2, κ.ο.κ.. Τελειώνετε στο Ε.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
            child: GestureDetector(
            child: CustomPaint(
                size: Size.infinite,
                painter: DotsPainter(points: points),
                child: Stack(
                  children: dotPositions.keys.map((label) {
                    final position = dotPositions[label]!;
                    return Positioned(
                      left: position.dx - 20,
                      top: position.dy - 20,
                      child: _buildDot(label),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (points.isNotEmpty) {
                        points.removeLast();
                      }
                    });
                  },
                  child: Text('Αναίρεση', style: TextStyle(color: Colors.pinkAccent[700]),
                  ),
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
                      MaterialPageRoute(builder: (context) => const CubeDrawingScreen()),
                    );
                  },
                  child: const Text('Επόμενο', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(String label) {
    return GestureDetector(
      onTap: () => _handleTap(label),
      child: CircleAvatar(
        radius: 20,
        child: Text(label, style: const TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  final List<Offset> points;

  DotsPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}