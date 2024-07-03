import 'package:flutter/material.dart';
import 'pizza_drawing.dart';
import 'score_manager.dart';

class CubeDrawingGame extends StatelessWidget {
  const CubeDrawingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CubeDrawingScreen(),
    );
  }
}

class CubeDrawingScreen extends StatefulWidget {
  const CubeDrawingScreen({super.key});

  @override
  _CubeDrawingScreenState createState() => _CubeDrawingScreenState();
}

class _CubeDrawingScreenState extends State<CubeDrawingScreen> {

  final String gameName = 'Αντιγραφή κύβου';
  int _score = 0;

  // Grid size
  static const int gridSize = 10;

  // Correct positions to form the cube
  final Set<Point> correctPositions = {
    Point(1,4), Point(1,5), Point(1,6), Point(1,7), Point(1,8), Point(1,9),
    Point(1,10), Point(2,10), Point(3,10), Point(4,10), Point(5,10), Point(6,10),
    Point(7,5), Point(7,6), Point(7,7), Point(7,8), Point(7,9), Point(7,10),
    Point(2,4), Point(3,4), Point(4,4), Point(5,4), Point(6,4), Point(7,4),
    Point(4,1), Point(4,2), Point(4,3), Point(4,5), Point(4,6), Point(4,7),
    Point(5,7), Point(6,7), Point(8,7), Point(9,7), Point(10,7),
    Point(10,1), Point(10,2), Point(10,3), Point(10,4), Point(10,5), Point(10,6),
    Point(5,1), Point(6,1), Point(7,1), Point(8,1), Point(9,1),
    Point(2,3), Point(3,2), Point(2,9), Point(3,8),
    Point(8,3), Point(9,2), Point(8,9), Point(9,8),
  };

  // User selected positions
  Set<Point> selectedPositions = <Point>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2. Αντιγραφή κύβου'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Χρωματίστε τα κατάλληλα κουτιά ώστε να αντιγράψετε αυτό το σχέδιο. Αξιοποιήστε όλες τις στήλες και τις γραμμές.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Image.asset(
            'assets/cube.png',
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double gridWidth = constraints.maxWidth;
                double gridHeight = constraints.maxHeight;
                double cellSize = (gridWidth < gridHeight ? gridWidth : gridHeight) / gridSize;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: cellSize * gridSize,
                      height: cellSize * gridSize,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final RenderBox renderBox = context.findRenderObject() as RenderBox;
                          final localPosition = renderBox.globalToLocal(details.globalPosition);
                          final row = (localPosition.dy / cellSize).floor() + 1;
                          final col = (localPosition.dx / cellSize).floor() + 1;

                          final point = Point(row, col);

                          if (row > 0 && row <= gridSize && col > 0 &&
                              col <= gridSize) {
                            setState(() {
                              selectedPositions.add(point);
                            });
                          }
                        },
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridSize,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final int row = (index ~/ gridSize) + 1;
                            final int col = (index % gridSize) + 1;
                            final Point point = Point(row, col);

                            return GestureDetector(
                              onTap: () {
                                toggleSelectedPoint(point);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2.0),
                                color: selectedPositions.contains(point) ? Colors.black : Colors.grey[300],
                              ),
                            );
                          },
                          itemCount: gridSize * gridSize,
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                      if (selectedPositions.isNotEmpty) {
                        selectedPositions.remove(selectedPositions.last);
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
                    checkResult();
                  // Pass the score and navigate to next game screen
                    ScoreManager().addScore(GameScore(gameName: gameName, score: _score));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PizzaDrawingScreen()),
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

  void toggleSelectedPoint(Point point) {
    setState(() {
      if (selectedPositions.contains(point)) {
        selectedPositions.remove(point);
      } else {
        selectedPositions.add(point);
      }
    });
  }

  void checkResult() {
    bool isCorrect = selectedPositions.containsAll(correctPositions) && correctPositions.containsAll(selectedPositions);

    if (isCorrect) {
      _score = 1;
    } else {
      _score = 0;
    }
  }
}

class Point {
  final int row;
  final int col;

  Point(this.row, this.col);

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Point && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
