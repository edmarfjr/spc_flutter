import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spc_flttr/game/hud.dart';

import 'package:spc_flttr/game/shooter_game.dart';
import 'package:spc_flttr/objetos/player.dart';

final game = FlameTester(ShooterGame.new);
void main() {
  group('testWithFlameGame', () {
    testWithFlameGame(
      'game is properly initialized',
      (game) async {
        expect(game.isLoaded, true);
        expect(game.isMounted, true);
      },
    );
  });

  group('testWithGame', () {
    List<String>? storedEvents;

    testWithGame<_RecordedGame>(
      'correct event sequence',
      _RecordedGame.new,
      (game) async {
        var events = <String>[];
        events = game.events;
        expect(
          events,
          ['onGameResize [800.0,600.0]', 'onLoad', 'onMount'],
        );
        // Save for the next test
        storedEvents = events;
      },
    );

    // This test may only be called after the previous test has run
    test(
      'Game.onRemove is called',
      () {
        expect(
          storedEvents,
          ['onGameResize [800.0,600.0]', 'onLoad', 'onMount', 'onRemove'],
        );
      },
    );
  });

   group('test HUD and Player initialization', () {
    testWithGame<ShooterGame>(
      'Player and HUD are initialized after clicking play button',
      ShooterGame.new,
      (game) async {
        // Inicializa o jogo com a tela de menu
        final shooterGame = game as ShooterGame;
        
        // Verifica se o jogo começa na tela de menu
        expect(shooterGame.router.currentRoute.name, 'menu');
        
        // Cria e adiciona a tela do menu
        final menuScreen = MenuScreen();
        shooterGame.add(menuScreen);

        // Verifica se o menu e o botão de jogar estão visíveis
        expect(menuScreen.children.isNotEmpty, true);

        // Localiza o botão de Play na tela do menu
        final playButton = menuScreen.children.query<ButtonComponent>().firstWhere(
              (component) => component is ButtonComponent,
              orElse: () => throw Exception('Botão de Play não encontrado'),
            );

        // Simula o clique no botão de Play, o que deve iniciar o jogo
         playButton.onPressed!();

        // Verifica se a tela de jogo foi carregada
        expect(shooterGame.router.currentRoute.name, 'game');

        // Força o "pump" para garantir que o jogo foi iniciado
        await game.ready();

        // Verifica se o Player foi adicionado corretamente
        final playerInGame = game.children.query<Player>().firstWhere(
              (component) => component is Player,
              orElse: () => throw Exception('Player não encontrado'),
            );

        // Verifica se o HUD foi adicionado corretamente
        final hudInGame = game.children.query<Hud>().firstWhere(
              (component) => component is Hud,
              orElse: () => throw Exception('HUD não encontrado'),
            );

        expect(playerInGame, isNotNull);
        expect(hudInGame, isNotNull);
      },
    );
  });

}

class _RecordedGame extends FlameGame {
  final List<String> events = [];

  @override
  void onMount() {
    super.onMount();
    events.add('onMount');
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    events.add('onLoad');
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    events.add('onGameResize $size');
  }

  @override
  void onRemove() {
    events.add('onRemove');
    super.onRemove();
  }
}