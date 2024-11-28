import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spc_flttr/fx.dart';
import 'package:spc_flttr/globals.dart';
import 'package:spc_flttr/projeteis.dart';
import 'package:spc_flttr/shooter_game.dart';

class Player extends SpriteComponent 
with HasGameRef<ShooterGame>, CollisionCallbacks {
  double targetAngle = 0.0;
  final double rotationSpeed = 15.0;
  late final SpawnComponent _bulletSpawner;
  double speed = 200;
  late TextComponent playerLabel;
 // 
 Vector2 moveDirection = Vector2.zero();
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
    add(RectangleHitbox());

    
  }
  @override
  void update(double dt) {
    super.update(dt);
   
    if (moveDirection.length > 0) {
      position.add(moveDirection.normalized() * (speed * dt));
      angle = lerpAngle(angle, targetAngle, rotationSpeed * dt);
      if (_bulletSpawner.timer.isRunning() == false){
        startShooting();
      }
    }else{
      if (_bulletSpawner.timer.isRunning()){
        stopShooting();
      }
    }
    position.clamp(Vector2.zero(), gameRef.size - size);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet && other.isIni) {
      //game.vidas --;
      game.mudaVida(-1);
      other.removeFromParent();
      if (game.vidas<=0){
        game.add(Explosion(position: position));
        game.onGameOver();
        removeFromParent();
        
      }
    }
  }

  void updateDirection(Vector2 direction) {
    moveDirection = direction;
  }

  void startShooting() {
    _bulletSpawner.timer.start();
    
  }

  void changeShootingPeriod(double p){
    _bulletSpawner.period = _bulletSpawner.period*p;
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }
}


