import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spc_flttr/shooter_game.dart';

class Bullet extends SpriteAnimationComponent with HasGameRef<ShooterGame> {
  final double speed = 300;

  Bullet({super.position, required double angle})
      : super(
          size: Vector2(25, 25),
          anchor: Anchor.center,
        ) {
    // Definir o ângulo inicial do projétil
    this.angle = angle;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: .1,
        textureSize: Vector2.all(8),
      ),
    );

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calcular o movimento do projétil com base no ângulo
    final direction = Vector2(sin(angle), -cos(angle)) * speed * dt;
    position.add(direction);

    // Remover o projétil se sair da tela
    if (position.y < -height ||
        position.y > gameRef.size.y ||
        position.x < 0 ||
        position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}
