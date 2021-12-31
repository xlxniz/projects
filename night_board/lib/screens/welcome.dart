import 'package:audio_manager/audio_manager.dart';
import 'package:night_board/screens/tic_tac_toe_board.dart';
import 'package:night_board/game_model/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Welcome extends StatelessWidget {
  var audio = AudioManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text("Night Board!"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 1),
            const Text(
              "Welcome!",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Select Your Game",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().user = "X";
                    context.read<GameBoardProvider>().playGame = true;
                    GameBoardView.StartGame(context);
                  },
                  child: const Text(
                    "Tic Tac Toe",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),

                  ),
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.blue
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text(
                    "Coming Soon",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.blue
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.music_note),
                  iconSize: 50,
                  color: AppColors.white,
                  onPressed: () {
                    //audio.start('assets/BabySteps.mp3', "Night Board music");
                  }
                )
              ],
            ),
          ]
        )
      ),
    );
  }
}
