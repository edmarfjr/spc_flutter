import 'package:flame/components.dart';
import 'package:spc_flttr/shooter_game.dart';

class Explosion extends SpriteAnimationComponent
    with HasGameReference<ShooterGame> {
  Explosion({
    super.position,
  }) : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
          removeOnFinish: true,
        );


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explode.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}