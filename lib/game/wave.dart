import 'dart:math';
import 'dart:ui';
//import 'package:flame/components.dart';
import 'package:spc_flttr/objetos/inimigos.dart';
import 'package:spc_flttr/game/shooter_game.dart';

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
        enemy = XenoSquid(onRemoveCallback: onEnemyDefeated, spwArea: game.size , gameCubit: game.gameCubit);
        break;
      case XenoMusk:
        enemy = XenoMusk(onRemoveCallback: onEnemyDefeated, spwArea: game.size , gameCubit: game.gameCubit);
        break;
      default:
        enemy = Meteoro(onRemoveCallback: onEnemyDefeated, spwArea: game.size , gameCubit: game.gameCubit);
    }
    game.add(enemy);
  }

  void onEnemyDefeated() {
    activeEnemies--;
    if (activeEnemies <= 0) {
      if(game.router.currentRoute.name == 'game'){onWaveComplete();}
      print('WAVE TERMINADA');
    }
  }

  Type getRandomEnemyType() {
    final random = Random();
    return iniTipo[random.nextInt(iniTipo.length)];
  }
}