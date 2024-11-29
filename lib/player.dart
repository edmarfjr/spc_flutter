import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:spc_flttr/fx.dart';
import 'package:spc_flttr/globals.dart';
import 'package:spc_flttr/inimigos.dart';
import 'package:spc_flttr/projeteis.dart';
import 'package:spc_flttr/shooter_game.dart';

class Player extends SpriteComponent 
with HasGameRef<ShooterGame>, CollisionCallbacks {
  double targetAngle = 0.0;
  final double rotationSpeed = 15.0;
  late final SpawnComponent _bulletSpawner;
  double speed = 200;
  late TextComponent playerLabel;
  late Timer hitTmr;
  bool isHit = false;
 // 
 Vector2 moveDirection = Vector2.zero();
  Player():super(
           size: Vector2(50, 50),
          anchor: Anchor.center,
        ){
          hitTmr = Timer(0.5, 
            //onTick: _mudaHit,
            autoStart: false,
          );
        }
   @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('spcship.png');

    position = gameRef.size / 2;

    _bulletSpawner = SpawnComponent(
      period: .4,
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
      //autoStart: false,
    );

    game.add(_bulletSpawner);
    add(RectangleHitbox());
    
  }
  @override
  void update(double dt) {
    super.update(dt);
    hitTmr.update(dt);
    if (moveDirection.length > 0) {
      position.add(moveDirection.normalized() * (speed * dt));
      angle = lerpAngle(angle, targetAngle, rotationSpeed * dt);
      
    }
    position.clamp(Vector2.zero(), gameRef.size - size);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (hitTmr.isRunning() == false && (other is Enemy|| (other is Bullet && other.isIni))) {
      //game.vidas --;
     // isHit = true;
      final effect = SequenceEffect([
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 0,
          opacityTo: 1,
        ),
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 1,
          opacityTo: 0.0,
        ),
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 0,
          opacityTo: 1,
        ),
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 1,
          opacityTo: 0.0,
        ),
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 0,
          opacityTo: 1,
        ),
        ColorEffect(
        const Color.fromARGB(255, 255, 0, 0),
          EffectController(duration: 0.5/6),
          opacityFrom: 1,
          opacityTo: 0.0,
        ),
      ]);
      add(effect);
      game.mudaVida(-1);
      hitTmr.start();
      if(other is Bullet ){
        other.removeFromParent();
      }
      if (game.vidas<=0){
        stopShooting();
        game.add(Explosion(position: position));
        game.onGameOver();
        game.joystick.removeFromParent();
        removeFromParent();
        
      }
    }
  }

  void updateDirection(Vector2 direction) {
    moveDirection = direction;
  }

  void startShooting() {
    try{
      _bulletSpawner.timer.start();
    }catch(e){
    }
  }

  void changeShootingPeriod(double p){
    _bulletSpawner.period = _bulletSpawner.period*p;
  }

  void stopShooting() {
    try{
      _bulletSpawner.timer.stop();
    }catch(e){
    }
  }
}


