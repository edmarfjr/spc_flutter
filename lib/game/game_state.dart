import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spc_flttr/game/dados.dart';

class GameState {
  final int pontos;
  final int vidas;
  //final Future<int> mortes;
  final bool hudVisible;

  const GameState({
    required this.pontos,
    required this.vidas,
   // required this.mortes,
    required this.hudVisible,
  });

  GameState copyWith({
    int? pontos,
    int? vidas,
   // int? mortes,
    bool? hudVisible
  })
  {
    return GameState(
      pontos: pontos ?? this.pontos,
      vidas: vidas ?? this.vidas, 
    //  mortes: mortes ?? this.mortes,
      hudVisible: hudVisible ?? this.hudVisible,
      );
  }

}

class GameCubit extends Cubit<GameState> {
  GameCubit()
      : super(const GameState(
          pontos: 0,
          vidas: 3,
        //  mortes: 1,
          hudVisible: false
        )){_loadHighScore();}

  void mudaPontos(int points) {
    emit(state.copyWith(pontos: state.pontos + points));
    _saveHighScore();
   // print('Pontos atualizados: ${state.pontos + points}'); // Debug
  }

  void mudaVidas(int v) {
    emit(state.copyWith(vidas: state.vidas + v));
    // print('VIdas atualizados: ${state.vidas + v}'); // Debug
  }

 // void mudaMortes(int v) {
  //  emit(state.copyWith(mortes: state.mortes + v));
 // }

  void resetaVidas(){
    emit(state.copyWith(vidas: 0));
  }

  void togleHud(){
    emit(state.copyWith(hudVisible: ! state.hudVisible));
  }

  /// Salva o high score
  Future<void> _saveHighScore() async {
    final currentHighScore = await ScorePersistence.getHighScore();
    if (state.pontos > currentHighScore) {
      await ScorePersistence.saveHighScore(state.pontos);
      print('Novo high score salvo: ${state.pontos}');
    }
  }

  /// Carrega o high score ao iniciar o jogo
  Future<void> _loadHighScore() async {
    final highScore = await ScorePersistence.getHighScore();
    print('High score carregado: $highScore');
  }
}