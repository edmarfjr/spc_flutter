import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/game_theme.dart';
import 'game/shooter_game.dart';

void main() {
  runApp(
    MaterialApp(
      theme: gameTheme,  // Aplica o tema globalmente
      home: GameWidget(game: ShooterGame()),
    ),
  );
}