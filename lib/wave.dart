import 'dart:math';
import 'dart:ui';

import 'package:spc_flttr/inimigos.dart';
import 'package:spc_flttr/shooter_game.dart';

class Wave {
  final int iniCont;
  final List<Type> iniTipo;
  final VoidCallback onWaveComplete;
  final ShooterGame game;
  int activeEnemies = 0;

 Wave({
    required this.iniCont,
    required this.iniTipo,
    required this.onWaveComplete,
    required this.game,
  });

  void startWave() {
    for (int i = 0; i < iniCont; i++) {
      spawnEnemy(getRandomEnemyType());
    }
  }

  void spawnEnemy(Type enemyType) {
    activeEnemies++;
    late Enemy enemy;
    switch (enemyType) {
      case XenoSquid:
        enemy = XenoSquid(onRemoveCallback: onEnemyDefeated, spwArea: game.size);
        break;
    //  case StrongEnemy:
     //   enemy = StrongEnemy(onRemoveCallback: onEnemyDefeated, spawnArea: game.size);
     //   break;
      default:
        enemy = Enemy(onRemoveCallback: onEnemyDefeated, spwArea: game.size);
    }
    game.add(enemy);
  }

  void onEnemyDefeated() {
    activeEnemies--;
    if (activeEnemies <= 0) {
      onWaveComplete();
    }
  }

  Type getRandomEnemyType() {
    final random = Random();
    return iniTipo[random.nextInt(iniTipo.length)];
  }
}