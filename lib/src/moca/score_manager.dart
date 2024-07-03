class ScoreManager {
  static final ScoreManager _instance = ScoreManager._internal();

  factory ScoreManager() {
    return _instance;
  }

  ScoreManager._internal();

  final List<GameScore> _scores = [];

  List<GameScore> get scores => _scores;

  void addScore(GameScore score) {
    _scores.add(score);
  }

  void resetScores() {
    _scores.clear();
  }
}

class GameScore {
  final String gameName;
  final int score;

  GameScore({required this.gameName, required this.score});
}
