import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/fx.dart';
import 'package:spc_flttr/globals.dart';
import 'package:spc_flttr/projeteis.dart';
import 'package:spc_flttr/shooter_game.dart';

class Enemy extends SpriteAnimationComponent
with HasGameRef<ShooterGame>, CollisionCallbacks {
  static const double enemySize = 50.0;
  static const double speed = 100.0;
  static const int pontos = 100;
  int vida = 1;
  double targetAngle = 0.0; // O ângulo para o qual o jogador deve girar
  final double rotationSpeed = 15.0;

  final VoidCallback onRemoveCallback;

  final Vector2 spwArea;
  late Vector2 direction;

  Enemy({required this.onRemoveCallback, required this.spwArea})
      : super(
          size: Vector2(enemySize, enemySize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

   /* sprite = await gameRef.loadSprite('mete.png');
      animation = await game.loadSpriteAnimation(
      'mete.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(14),
      ),
    );
   */ 
    position = _getRandomSpawnPosition(spwArea);
    direction = _getRandomDirection();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    targetAngle = -direction.angleToSigned(Vector2(0, -1));
    angle = lerpAngle(angle, targetAngle, rotationSpeed * dt);
    position.add(direction * (speed * dt)); // Movimenta o inimigo

    if (position.y > game.size.y) {
      //removeFromParent();
      position.y = 0;
    }

    if (position.y < 0) {
      //removeFromParent();
      position.y = game.size.y;
    }

    if (position.x > game.size.x) {
      //removeFromParent();
      position.x = 0;
    }

    if (position.x < 0) {
      //removeFromParent();
      position.x = game.size.x;
    }

  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      vida --;
      
      other.removeFromParent();
      if (vida<=0){
        removeFromParent();
        onRemoveCallback(); 
        game.addPontos(pontos);
        game.add(Explosion(position: position));
      }
    }
  }

  // Calcula uma posição inicial aleatória em uma das bordas da tela
  Vector2 _getRandomSpawnPosition(Vector2 area) {
    final random = Random();
    final edge = random.nextInt(4); // 0: superior, 1: inferior, 2: esquerda, 3: direita
    switch (edge) {
      case 0: // Superior
        return Vector2(random.nextDouble() * area.x, -enemySize);
      case 1: // Inferior
        return Vector2(random.nextDouble() * area.x, area.y);
      case 2: // Esquerda
        return Vector2(-enemySize, random.nextDouble() * area.y);
      case 3: // Direita
        return Vector2(area.x, random.nextDouble() * area.y);
      default:
        return Vector2.zero();
    }
  }

  // Gera uma direção aleatória como um vetor unitário
  Vector2 _getRandomDirection() {
    final random = Random();
    final angle = random.nextDouble() * 2 * pi; // Ângulo aleatório em radianos
    return Vector2(cos(angle), sin(angle)); // Vetor unitário na direção do ângulo
  }

}

class XenoSquid extends Enemy{
  late Timer updTrgtTmr;

  static const double enemySize = 50.0;
  static const double speed = 200.0;
  static const int pontos = 150;
  late Vector2 targetPosition;
  
  XenoSquid({
    required super.onRemoveCallback, 
    required super.spwArea
  }){
updTrgtTmr = Timer(1.0, onTick: _updateTarget, repeat: true);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = await game.loadSpriteAnimation(
      'alien1.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );
    _updateTarget(); // Define o alvo inicial
    updTrgtTmr.start();
    super.vida = 3;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updTrgtTmr.update(dt);
    
  }

  void _updateTarget() {
    // Atualiza o alvo para a posição atual do jogador
    targetPosition = Vector2(game.player.position.x,game.player.position.y) ; // Substitua pela lógica da posição do jogador
    super.direction = (targetPosition - position).normalized();
  }
}
