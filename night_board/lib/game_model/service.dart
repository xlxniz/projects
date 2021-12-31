import 'package:tuple/tuple.dart';
import 'dart:math';

class Result {
  final double value;
  final Tuple2<int, int> action;

  Result(this.value, this.action);
}

class GameService {
  final player1 = "X";
  final player2 = "O";

  String getActivePlayer(List<List<String>> setBoardState) {
    int countO = 0;
    int countX = 0;
    for (final row in setBoardState) {
      for (final cell in row) {
        if (cell == "O") countO++;
        if (cell == "X") countX++;
      }
    }
    return countO == 0 && countX == 0 || countO == countX ? player1 : player2;
  }

  bool finalScores(List<List<String>> board) {
    final winningPlayer = winner(board);
    if (winningPlayer == player1 || winningPlayer == player2) {
      return true;
    }

    for (final row in board) {
      if (row.contains(null)) {
        return false;
      }
    }

    return true;
  }

  String winner(List<List<String>> board) {
    ///Row winner
    for (final row in board) {
      int countX = 0;
      int countO = 0;

      for (final cell in row) {
        if (cell == player1) {
          countX++;
        } else if (cell == player2) {
          countO++;
        }
      }

      if (countX == 3) {
        return player1;
      } else if (countO == 3) {
        return player2;
      }
    }

    ///Column Winner
    for (var i = 0; i < 3; i++) {
      int columnCountX = 0;
      int columnCountO = 0;
      for (var j = 0; j < 3; j++) {
        if (board[j][i] == player1) {
          columnCountX++;
        } else if (board[j][i] == player2) {
          columnCountO++;
        }
      }

      if (columnCountX == 3) return player1;
      if (columnCountO == 3) return player2;
    }

    /// Diagonal Winners
    for (final actor in [player1, player2]) {
      final diagonalWinOne =
          board[0][0] == actor && board[1][1] == actor && board[2][2] == actor;
      final diagonalWinTwo =
          board[0][2] == actor && board[1][1] == actor && board[2][0] == actor;

      if (diagonalWinOne || diagonalWinTwo) {
        return actor;
      }
    }
    return null;
  }

  double scoreTracker(List<List<String>> board) {
    final winningPlayer = winner(board);
    if (winningPlayer == player1) {
      return 1;
    } else if (winningPlayer == player2) {
      return -1;
    } else {
      return 0;
    }
  }

  Tuple2<int, int> miniMax(List<List<String>> setBoardState, String activePlayer) {
    if (activePlayer == player1) {
      return maxValue(setBoardState).action;
    }

    return minValue(setBoardState).action;
  }

  Result maxValue(List<List<String>> setBoardState) {
    if (finalScores(setBoardState)) {
      return Result(scoreTracker(setBoardState), null);
    }
    double v = -double.infinity;
    Tuple2<int, int> highestValuedAction;
    for (final action in actions(setBoardState)) {
      final lowResult = minValue(result(setBoardState, action));
      if (v != max(v, lowResult.value)) {
        highestValuedAction = action;
      }

      v = max(v, lowResult.value);
    }

    return Result(v, highestValuedAction);
  }

  Result minValue(List<List<String>> setBoardState) {
    if (finalScores(setBoardState)) {
      return Result(scoreTracker(setBoardState), null);
    }

    double v = double.infinity;
    Tuple2<int, int> lowestValuedAction;

    for (final action in actions(setBoardState)) {
      final maxResult = maxValue(result(setBoardState, action));
      if (v != min(v, maxResult.value)) {
        lowestValuedAction = action;
      }

      v = min(v, maxResult.value);
    }
    return Result(v, lowestValuedAction);
  }

  Set<Tuple2<int, int>> actions(List<List<String>> setBoardState) {
    final Set<Tuple2<int, int>> possibleActions = {};

    for (var i = 0; i < setBoardState.length; i++) {
      for (var j = 0; j < setBoardState[i].length; j++) {
        if (setBoardState[i][j] == null) {
          possibleActions.add(Tuple2(i, j));
        }
      }
    }
    return possibleActions;
  }

  List<List<String>> result(
      List<List<String>> setBoardState,
      Tuple2<int, int> action,
      ) {
    if (setBoardState[action.item1][action.item2] != null) {
      throw ArgumentError("Error");
    }

    final String currentPlayer = getActivePlayer(setBoardState);

    final List<List<String>> resetState = [];

    for (int i = 0; i < setBoardState.length; i++) {
      resetState.add([]);
      for (int j = 0; j < setBoardState.length; j++) {
        resetState[i].add(setBoardState[i][j]);
      }
    }

    resetState[action.item1][action.item2] = currentPlayer;
    return resetState;
  }
}
