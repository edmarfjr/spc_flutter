import 'dart:math';

import 'package:flame/components.dart';
import 'package:spc_flttr/globals.dart';
import 'package:spc_flttr/projeteis.dart';
import 'package:spc_flttr/shooter_game.dart';

class Player extends SpriteComponent 
with HasGameRef<ShooterGame> {
  double targetAngle = 0.0; // O ângulo para o qual o jogador deve girar
  final double rotationSpeed = 15.0; // Velocidade de rotação (rad/s)
  late final SpawnComponent _bulletSpawner;
 // 
  Player()
    
      : super(
           size: Vector2(50, 50),
          anchor: Anchor.center,
        );

   @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('spcship.png');

    position = gameRef.size / 2;

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
               sin(angle)*25,//-width / 2,
              -cos(angle)*25,//-height / 2,
              ),
              angle: angle,
        );

        //return bullet;
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
  }
  @override
  void update(double dt) {
    super.update(dt);

    // Interpola suavemente o ângulo atual para o ângulo alvo
    angle = lerpAngle(angle, targetAngle, rotationSpeed * dt);
  }
  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }
}


