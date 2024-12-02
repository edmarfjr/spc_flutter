//import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spc_flttr/game/dados.dart';
import 'package:spc_flttr/game/game_state.dart';
import 'package:spc_flttr/game/shooter_game.dart';

class Hud extends PositionComponent with FlameBlocListenable<GameCubit, GameState>,HasVisibility {

  final ShooterGame game;
  late TextComponent pontosTxt;
  late TextComponent waveTxt;
  late TextComponent vidaTxt;

  Hud({required this.game}) : super(size: Vector2(200, 100));

  @override
  
    Future<void> onLoad() async {
      
      super.onLoad();
      //isVisible = false;
      pontosTxt = TextComponent(
        text: 'Score: 0',
        position: Vector2(10, 10),
      );
      vidaTxt = TextComponent(
        text: '',
        position: Vector2(game.size.x/2, 10),
      );
      add(pontosTxt);
      add(vidaTxt);

      final highScore = await ScorePersistence.getHighScore();
      pontosTxt.text = '$highScore';
    //  print('Hud carregada e pronta');
    }

    @override
  void onNewState(GameState state) {
    pontosTxt.text = 'Score: ${state.pontos}';
    vidaTxt.text = 'Lives: ${state.vidas}';
    
    isVisible = state.hudVisible;
    // print('HUD atualizada: Points ${state.pontos}, Lives ${state.vidas}'); // Debug
  }

  
}

  

