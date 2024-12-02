import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/game/shooter_game.dart';

class Upgrade {
  final String name;
  final VoidCallback applyEffect;

  Upgrade({required this.name, required this.applyEffect});
}

class UpgradeMenu extends PositionComponent with HasGameRef<ShooterGame> {
  final List<Upgrade> upgrades;

  UpgradeMenu({required this.upgrades});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var buttonWidth = gameRef.canvasSize.x*0.7;
    var buttonHeight = gameRef.canvasSize.y*0.2;
    var spacing = gameRef.canvasSize.y*0.02;
    final caixa = PositionComponent(
      position: gameRef.size/2,
      anchor: Anchor.center,
      children: [
        RectangleComponent(
          size : Vector2(gameRef.canvasSize.x*0.9, gameRef.canvasSize.y*0.8),
          anchor: Anchor.center,
          paint: Paint()..color = Colors.black
                                ..style = PaintingStyle.fill,
          
        ),
        RectangleComponent(
          size : Vector2(gameRef.canvasSize.x*0.9, gameRef.canvasSize.y*0.8),
          anchor: Anchor.center,
          paint: Paint()..color = Colors.white
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3,
          
        ),
      ]
    );
    
    add(caixa);
    for (int i = 0; i < upgrades.length; i++) {
      final upgrade = upgrades[i];
      final button = ButtonComponent(
        button: PositionComponent(
          size: Vector2(buttonWidth, buttonHeight),
         
          children: [
          RectangleComponent(
            size: Vector2(buttonWidth, buttonHeight),
            paint: Paint()..color = Colors.black
                            ..style = PaintingStyle.fill
          ),
          RectangleComponent(
            size: Vector2(buttonWidth, buttonHeight),
            paint: Paint()..color = Colors.white
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3, 
          ),
          TextComponent(
            text: upgrade.name,
            size: Vector2(buttonWidth, buttonHeight),
            anchor: Anchor.center,
            textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
            position: Vector2(buttonWidth, buttonHeight)/2,
          ),
        ],
        ),
        onPressed: () {
          upgrade.applyEffect();
          game.nextWave();
          if (game.gameCubit.state.vidas>0){
            game.player.startShooting();
          }
          removeFromParent(); 
        },
    
      );

      button.position = Vector2(
        gameRef.size.x / 2 - buttonWidth / 2,
        gameRef.size.y / 2 - (upgrades.length * (buttonHeight + spacing)) / 2 +
            i * (buttonHeight + spacing),
      );
      
      add(button);
    }
  }

 

}
