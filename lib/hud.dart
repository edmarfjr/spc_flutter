//import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/shooter_game.dart';

class Hud extends PositionComponent {

  final ShooterGame game;
  late TextComponent pontosTxt;
  late TextComponent waveTxt;
  late TextComponent vidaTxt;

  Hud({required this.game}) : super(size: Vector2(200, 100));

  @override
    Future<void> onLoad() async {
      super.onLoad();
      pontosTxt = TextComponent(
        text: "Pontos: ${game.pontos}",
        position: Vector2(10, 10), // Posição no HUD
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
      add(pontosTxt);

      vidaTxt = TextComponent(
        text: "${game.vidas}",
        position: Vector2(game.canvasSize.x/2, 10), // Posição no HUD
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
      add(vidaTxt);

    }

    void updateScore(int newScore) {
        pontosTxt.text = "Pontos: $newScore";
      }

      void updateLives(int newLives) {
        vidaTxt.text = "Vidas: $newLives";
      }

  }

