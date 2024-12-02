import 'package:shared_preferences/shared_preferences.dart';

class ScorePersistence {
  static const _scoreKey = 'high_score';

  /// Salva o score
  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
     print('Salvando high score: $score'); // Debug
    await prefs.setInt(_scoreKey, score);
  }

  /// Recupera o score
  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
  final highScore = prefs.getInt(_scoreKey) ?? 0;
  print('High score carregado: $highScore'); // Debug
  return highScore;
  }
}