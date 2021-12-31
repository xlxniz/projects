import 'package:night_board/game_model/service.dart';
import 'package:flutter/material.dart';

class GameBoardProvider extends ChangeNotifier {
  GameService service;

  GameBoardProvider({this.service});

  List<List<String>> _boardState = [
    [null, null, null],
    [null, null, null],
    [null, null, null]
  ];

  final player1 = "X";
  final player2 = "O";

  String user;
  bool playGame = false;
  String _activePlayer = "X";
  bool _gameOver = false;
  String _winner;

  List<List<String>> get boardState => _boardState;

  String get activePlayer => _activePlayer;

  bool get gameOver => _gameOver;

  String get winner => _winner;


  void userTurn(int ix, int iy) {
    turn(ix, iy);
    if (_gameOver != true && !playGame) {}
  }

  void turn(int ix, int jy) {
    _boardState[ix][jy] = _activePlayer;

    if (service.finalScores(_boardState)) {
      _gameOver = true;
      _winner = service.winner(_boardState);
    } else {
      nextPlayer();
    }

    notifyListeners();
  }

  void nextPlayer() {
    if (_activePlayer == "X") {
      _activePlayer = "O";
    } else {
      _activePlayer = "X";
    }
  }

  void reset() {
    user = null;
    _activePlayer = player1;
    _boardState = [
      [null, null, null],
      [null, null, null],
      [null, null, null]
    ];
    _winner = null;
    _gameOver = false;
    playGame = false;
  }
}