import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:night_board/game_model/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:night_board/screens/share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../main.dart';
import 'dart:ui' as ui;
import 'dart:async';

class GameBoardView extends StatelessWidget {

  static Future<void> StartGame(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameBoardView(),
    ));
    context.read<GameBoardProvider>().reset();
    //context.read<Login>();
  }
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final gameBoardProvider = context.watch<GameBoardProvider>();
    final activePlayer = gameBoardProvider.activePlayer;
    final user = gameBoardProvider.user;
    final boardState = gameBoardProvider.boardState;
    final gameOver = gameBoardProvider.gameOver;
    final winner = gameBoardProvider.winner;
    final activeGame = gameBoardProvider.playGame;

    if (gameOver == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Screenshot(
            controller: screenshotController,
            child: AlertDialog(
              backgroundColor: AppColors.orange,
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().reset();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Reset"),
                ),
                ///screenshot.dart to capture and save image of scorecard
                TextButton(
                  onPressed: () {
                    //takeScreenShot;
                    screenshotController
                      .capture(delay: Duration(milliseconds: 5))
                      .then((capturedImage) async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Share()));
                    });
                  },
                  child: const Text("Share"),
                ),
              ],
            content: Text(
              getScores(winner, user, activeGame),
            ),
          ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.only(top: 50.0),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: 9,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: isCellActive(boardState, index) &&
                            isActive(
                              user,
                              activePlayer,
                              activeGame,
                            )
                            ? () {
                          context
                              .read<GameBoardProvider>()
                              .userTurn(index % 3, index ~/ 3);
                        }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.white,
                            ),
                          ),
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Text(
                                isCellActive(boardState, index)
                                    ? ""
                                    : boardState[index % 3][index ~/ 3].toString(),
                                style: const TextStyle(fontSize: 55, color: AppColors.white),
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getScores(String winner, String user, bool activeGame) {
    if (activeGame && winner != null) {
      return "$winner wins!!! Score: 100000";
    } else if (user != null && user == winner) {
      return "$winner wins! Score: 100000";
    } else if (user != winner && winner != null) {
      return "Sorry you lose! Score: 0";
    } else {
      return "No winner! Score: 0";
    }
  }

  bool isCellActive(List<List<String>> boardState, int index) =>
      boardState[index % 3][index ~/ 3] == null;

  bool isActive(
      String user, String activePlayer, bool activeGame) =>
      activeGame ? true : user == activePlayer;

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  saveScreenshot() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(
        format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }
  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}