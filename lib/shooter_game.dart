import 'package:flame/components.dart';
import 'package:flame/events.dart';
//import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/hud.dart';
import 'package:spc_flttr/inimigos.dart';
import 'package:spc_flttr/player.dart';
import 'package:spc_flttr/upgrades.dart';
import 'package:spc_flttr/wave.dart';

// ignore: implementation_imports
import 'package:flame/src/components/route.dart' as flame;

class ShooterGame extends FlameGame with TapDetector, HasCollisionDetection{
  late Player player;
  late Hud hud;
  int curwave = 0;
  late List<Wave> waves;
  int actInis = 0;

  int pontos = 0;
  int vidas = 3;

  late final SpawnComponent spawnComponent;

  late final RouterComponent router;
  late final DynamicJoystick  joystick;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    router = RouterComponent(
      routes: {
        'menu': flame.Route(MenuScreen.new),
        'game': flame.Route(GameScreen.new),
        'gameover': flame.Route(()=>GameOverScreen(finalScore: pontos)),
      },
      initialRoute: 'menu',
    );
     joystick = DynamicJoystick(
    
      knob: CircleComponent(
       radius: 10,
        paint: Paint()..color = Colors.blue,
      ),
      background: CircleComponent(
       radius: 20,
        paint: Paint()..color = Colors.grey,
      ),
      
     
    );
    add(router);

    add(joystick);
    player = Player();
  }

  @override
  void onTapDown(TapDownInfo info) {
  // Converte a posição da tela para a posição do mundo do jogo
 final worldPosition = info.eventPosition.global;
  //player.startShooting();
  // Mostra o joystick no local do toque
  joystick.showAt(worldPosition);

  super.onTapDown(info);
}

  @override
  void onTapUp(TapUpInfo info) {
    joystick.hide();
  }

  @override
  void onTap(){
    player.startShooting();
  }

  @override
  void onTapCancel(){
    player.stopShooting();
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.moveDirection = joystick.relativeDelta;
    player.targetAngle = -joystick.relativeDelta.angleToSigned(Vector2(0, -1));
    }


  void startGame() {
    
    router.pushReplacementNamed('game');
    add(player);
  }

  void endGame(int finalScore) {
    router.pushReplacementNamed('gameover');
  }

  void onGameOver() {
  endGame(pontos);
  curwave=0;
  pontos=0;
  vidas=3;
}

 

  void nextWave() {
    curwave++;
    if (curwave < waves.length) {
      waves[curwave].startWave();
    } else {
      // Todas as ondas foram concluídas
    //  print("Você venceu o jogo!");
    }
  }

  void addPontos(int pt){
    pontos += pt;
    hud.updateScore(pontos);
  }

 void mudaVida(int pt){
   vidas += pt;
    hud.updateLives(vidas);
  }

  
}

class GameScreen extends Component with HasGameRef<ShooterGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    

   game.hud = Hud(game: game);
    add(game.hud);

    final parallax = await game.loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    //game.player = Player();

    //add(game.player);

    //defi waves
    game.waves = [
      Wave(
        iniCont: 3, 
        iniTipo: [XenoSquid],
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
      Wave(
        iniCont: 5, 
        iniTipo: [XenoSquid],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
      Wave(
        iniCont: 5, 
        iniTipo: [XenoSquid,XenoMusk],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
      Wave(
        iniCont: 5, 
        iniTipo: [XenoMusk],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
      Wave(
        iniCont: 7, 
        iniTipo: [XenoSquid],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
      Wave(
        iniCont: 7, 
        iniTipo: [XenoSquid,XenoMusk],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: game,
      ),
    ];

    game.waves[game.curwave].startWave();
  }

  void showUpgradeMenu() {
  final upgrades = [
    Upgrade(
      name: "Aumentar Velocidade",
      applyEffect: () => game.player.speed *= 1.15,
    ),
    Upgrade(
      name: "Mais Vida",
      applyEffect: () => game.mudaVida(1),
    ),
    Upgrade(
      name: "Aumenta taxa de Tiro",
      applyEffect: () => game.player.changeShootingPeriod(0.8) ,
    ),
  ];

  final menu = UpgradeMenu(upgrades: upgrades);
  add(menu);
}


  

}

class MenuScreen extends Component with HasGameRef<ShooterGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final title = TextComponent(
      text: 'Shooter Game',
      textRenderer: TextPaint(style: const TextStyle(fontSize: 32, color: Colors.white)),
      position: gameRef.size / 2 - Vector2(0, 50),
      anchor: Anchor.center,
    );

    final playButton = ButtonComponent(
      button: PositionComponent(
        size: Vector2(200, 50),
        children: [
          RectangleComponent(
            size: Vector2(200, 50),
            paint: Paint()..color = Colors.blue, 
          ),
          TextComponent(
            text: 'Start Game',
            textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
            position: Vector2(50, 10),
          ),
        ],
      ),
      onPressed: () => gameRef.startGame(),
    );

    playButton.position = gameRef.size / 2 - Vector2(100, -50);

    add(title);
    add(playButton);
  }
}

class GameOverScreen extends Component with HasGameRef<ShooterGame> {
  final int finalScore;

  GameOverScreen({required this.finalScore});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final gameOverText = TextComponent(
      text: 'Game Over',
      textRenderer: TextPaint(style: const TextStyle(fontSize: 32, color: Colors.red)),
      position: gameRef.size / 2 - Vector2(0, 100),
      anchor: Anchor.center,
    );

    final scoreText = TextComponent(
      text: 'Final Score: $finalScore',
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
      position: gameRef.size / 2 - Vector2(0, 50),
      anchor: Anchor.center,
    );

    final restartButton = ButtonComponent(
      button: PositionComponent(
        size: Vector2(200, 50),
        children: [
          RectangleComponent(
            size: Vector2(200, 50),
            paint: Paint()..color = Colors.blue, 
          ),
          TextComponent(
            text: 'Restart',
            textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
            position: Vector2(50, 10),
          ),
        ],
      ),
      onPressed: () => gameRef.router.pushReplacementNamed('menu'),
    );

    restartButton.position = gameRef.size / 2 - Vector2(100, -50);

    add(gameOverText);
    add(scoreText);
    add(restartButton);
  }
}

class DynamicJoystick extends JoystickComponent {
   bool isVisible = false;
  DynamicJoystick({
    required super.knob,
    required super.background,
  }) : super(position: Vector2(100, 100)) {
    anchor = Anchor.center; // Centraliza o joystick
  }
    void showAt(Vector2 position) {
    // Torna o joystick visível e o posiciona
    this.position = position;
    isVisible = true;
  }

  void hide() {
    // Esconde o joystick
    isVisible = false;
  }
}