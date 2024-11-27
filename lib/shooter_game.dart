import 'package:flame/components.dart';
import 'package:flame/events.dart';
//import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/hud.dart';
import 'package:spc_flttr/inimigos.dart';
import 'package:spc_flttr/player.dart';
import 'package:spc_flttr/wave.dart';

class ShooterGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Player player;
  late Hud hud;
  int curwave = 0;
  late List<Wave> waves;
  int actInis = 0;

  int pontos = 0;
  int vidas = 3;

  late final SpawnComponent spawnComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hud = Hud(game: this);
    add(hud);

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    player = Player();

    add(player);

    //defi waves
    waves = [
      Wave(
        iniCont: 3, 
        iniTipo: [XenoSquid],
        onWaveComplete: nextWave,
        game: this,
      ),
      Wave(
        iniCont: 3, 
        iniTipo: [XenoSquid],
        onWaveComplete: nextWave,
        game: this,
      ),
    ];

    waves[curwave].startWave();
  }

  void nextWave() {
    curwave++;
    if (curwave < waves.length) {
      waves[curwave].startWave();
    } else {
      // Todas as ondas foram concluídas
    //  print("Você venceu o jogo!");
    }
  }

  void addPontos(int pt){
    pontos += pt;
    hud.updateScore(pontos);
  }

 

 /* @override
  void update(double dt) {
    super.update(dt);
  /*  if (spwInis >= maxIni) {
      spawnComponent.timer.stop(); // Para o spawn quando o limite é atingido
    } else {
    //  spawnComponent.timer.start(); // Reinicia se cair abaixo do limite
    }
*/  }
*/

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
    // Calcula o ângulo do vetor de movimento
    final delta = info.delta.global;
    player.targetAngle = -delta.angleToSigned(Vector2(0, -1));
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }
}

