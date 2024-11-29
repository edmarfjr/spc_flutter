import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/shooter_game.dart';

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

    for (int i = 0; i < upgrades.length; i++) {
      final upgrade = upgrades[i];
      final button = ButtonComponent(
        button: PositionComponent(
          size: Vector2(buttonWidth, buttonHeight),
         
          children: [
            RectangleComponent(
              size: Vector2(buttonWidth, buttonHeight),
              paint: Paint()..color = Colors.blue,
            ),
            TextBoxComponent(
              size: Vector2(buttonWidth, buttonHeight),
              text: upgrade.name,
            ),
          ],
        ),
        onPressed: () {
          upgrade.applyEffect();
          game.nextWave();
          removeFromParent(); // Remove o menu após a seleção
        },
       /* children: [
          TextComponent(
            text: upgrade.name,
            position: Vector2(10, 10),
          ),
        ],*/
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
