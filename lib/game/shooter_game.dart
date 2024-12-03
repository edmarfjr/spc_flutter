import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:spc_flttr/game/game_state.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spc_flttr/game/hud.dart';
import 'package:spc_flttr/objetos/inimigos.dart';
import 'package:spc_flttr/objetos/player.dart';
import 'package:spc_flttr/game/upgrades.dart';
import 'package:spc_flttr/game/wave.dart';
import 'package:flame/src/components/route.dart' as flame;

class ShooterGame extends FlameGame with TapDetector, HasCollisionDetection{
  late Player player;
  late Hud hud;
  int curwave = 0;
  late List<Wave> waves;
  int actInis = 0;
  late GameCubit gameCubit;

  late final SpawnComponent spawnComponent;

  late final RouterComponent router;
  late final DynamicJoystick  joystick;
  
  //late final Storage storage;
  late final mortes;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //storage = Storage();
    gameCubit = GameCubit();

    add(FlameBlocProvider<GameCubit, GameState>(
      create: () => gameCubit,
      children: [
        Hud(game: this),
      ],
    ));

    router = RouterComponent(
      routes: {
        'menu': flame.Route(MenuScreen.new),
        'game': flame.Route(GameScreen.new),
        'gameover': flame.Route(()=>GameOverScreen(finalScore: gameCubit.state.pontos)),
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
    
    player = Player(gameCubit);
    waves = [
      Wave(
        iniCont: 5, 
        iniTipo: [Meteoro],
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
      Wave(
        iniCont: 3, 
        iniTipo: [XenoSquid],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
      Wave(
        iniCont: 5, 
        iniTipo: [XenoSquid,XenoMusk],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
      Wave(
        iniCont: 5, 
        iniTipo: [XenoMusk],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
      Wave(
        iniCont: 7, 
        iniTipo: [XenoSquid],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
      Wave(
        iniCont: 7, 
        iniTipo: [XenoSquid,XenoMusk,Meteoro],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
       Wave(
        iniCont: 9, 
        iniTipo: [Meteoro],//XenoMusk
        onWaveComplete: showUpgradeMenu,
        game: this,
      ),
    ];

   

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
    player.startShooting();
    add(joystick);
   // print('START GAME');
    waves[curwave].startWave();
    gameCubit.togleHud();
  }

  void endGame(int finalScore) {
    router.pushReplacementNamed('gameover');

  }

  void onGameOver() {
    endGame(gameCubit.state.pontos);
    curwave=0;
    gameCubit.togleHud();
    gameCubit.mudaPontos(-gameCubit.state.pontos);
    gameCubit.mudaVidas(3);
  }

  void nextWave() {
    curwave++;
  //  print('CURWAVE: {$curwave}');
    if (curwave < waves.length) {
      waves[curwave].startWave();
    } else {
      onGameOver();
    }
  }

  void showUpgradeMenu() {
    player.stopShooting();
    final upgrades = [
      Upgrade(
        name: "Aumentar Velocidade",
        applyEffect: () => player.speed *= 1.2,
      ),
      Upgrade(
        name: "Mais Vida",
        applyEffect: () => gameCubit.mudaVidas(1),
      ),
      Upgrade(
        name: "Aumenta taxa de Tiro",
        applyEffect: () => player.changeShootingPeriod(0.8) ,
      ),
  ];

  final menu = UpgradeMenu(upgrades: upgrades);
  add(menu);
  }

  @override
  void onTapDown(TapDownInfo info){
    joystick.showAt(info.eventPosition.global);  
  }  

   @override
  void onTapUp(TapUpInfo info){
    //joystick.hide();  
  }  
}

class GameScreen extends Component with HasGameRef<ShooterGame> {
  late final TextComponent debugTxt;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    

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

    game.player.startShooting();

  }

  @override 
  void update (double dt)
  {
    super.update(dt);
  //  debugTxt.text = game.waves[game.curwave].activeEnemies.toString();
  }

}

class MenuScreen extends Component with HasGameRef<ShooterGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final title = TextComponent(
      text: 'Flame in Space',
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
            paint: Paint()..color = Colors.white
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2, 
          ),
          TextComponent(
            text: 'Start Game',
            anchor: Anchor.center,
            textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
            position: Vector2(100, 25),
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
            paint: Paint()..color = Colors.white
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2, 
          ),
          TextComponent(
            text: 'Restart',
            anchor: Anchor.center,
            textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
            position: Vector2(100, 25),
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

class DynamicJoystick extends JoystickComponent with HasVisibility {
   //bool isVisible = false;
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