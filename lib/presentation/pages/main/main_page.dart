import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/bloc/main/main_cubit.dart';
import 'package:wordle/data/dictionary_interactor.dart';
import 'package:wordle/data/entities/flushbar_types.dart';
import 'package:wordle/presentation/pages/main/widgets/keyboard_en.dart';
import 'package:wordle/presentation/pages/main/widgets/word_grid.dart';
import 'package:wordle/presentation/widgets/adaptive_scaffold.dart';
import 'package:wordle/resources/app_colors.dart';
import 'package:wordle/resources/r.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int level = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => _showTimerIfNeeded(context));
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      child: BlocProvider<MainCubit>(
        create: (BuildContext context) => MainCubit(),
        child: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {
            if (state is TopMessageState) {
              _showMessage(context, state);
            } else if (state is WinGameState) {
              _makeWin(context);
            } else if (state is LoseGameState) {
              _makeLose(context);
            }
          },
          buildWhen: (_, currState) => currState is MainInitial,
          builder: (context, state) {
            return Column(
              key: UniqueKey(),
              children: const [
                WordGrid(),
                Spacer(),
                KeyboardEn(),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMessage(
    final BuildContext context,
    final TopMessageState myMessage,
  ) {
    switch (myMessage.type) {
      case FlushBarTypes.notFound:
        Flushbar(
          message: R.stringsOf(context).word_not_found,
          duration: const Duration(seconds: 1),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Theme.of(context).primaryColorDark,
          messageColor: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(10),
        ).show(context);
        break;
      case FlushBarTypes.notCorrectLength:
        Flushbar(
          message: R.stringsOf(context).word_too_short,
          duration: const Duration(seconds: 1),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Theme.of(context).primaryColorDark,
          messageColor: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(10),
        ).show(context);
        break;
    }
  }

  Future<void> _showTimerIfNeeded(final BuildContext context) async {
    final s = await DictionaryInteractor.getInstance().createWord();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("last_game_word")) {
      if (prefs.getString("last_game_word") == s) {
        _showTimerDialog(context, prefs.getBool("last_game_result") ?? false);
      }
    }
  }

  Future<void> _makeWin(final BuildContext context) async {
    await _writeResults(true);
    _showTimerIfNeeded(context);
  }

  Future<void> _makeLose(final BuildContext context) async {
    await _writeResults(false);
    _showTimerIfNeeded(context);
  }

  Future<void> _writeResults(bool isWin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastWord = DictionaryInteractor.getInstance().secretWord;
    if (lastWord.isNotEmpty) {
      await prefs.setString('last_game_word', lastWord);
      await prefs.setBool('last_game_result', isWin);
    }
  }

  void _showTimerDialog(final BuildContext context, final bool isWin) {
    final now = DateTime.now();
    final nextMidnight =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final int endTime = DateTime.now().millisecondsSinceEpoch +
        nextMidnight.difference(now).inMilliseconds;
    final CountdownTimerController _countDownController =
        CountdownTimerController(endTime: endTime, onEnd: _dismissTimerDialog);
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext ctx) {
        final mainCubit = BlocProvider.of<MainCubit>(context);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            backgroundColor: isWin ? AppColors.green : Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        isWin
                            ? R.stringsOf(context).win_message
                            : R.stringsOf(context).lose_message,
                        style: GoogleFonts.mulish(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      level++;
                      await mainCubit.clearGameArea(level: level);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          R.stringsOf(context).next_wordle,
                          style: GoogleFonts.mulish(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CountdownTimer(
                    controller: _countDownController,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      if (time == null) {
                        return Container();
                      }
                      final duration = Duration(
                        hours: time.hours ?? 0,
                        minutes: time.min ?? 0,
                        seconds: time.sec ?? 0,
                      );

                      return Text(
                        _durationToString(duration),
                        style: GoogleFonts.mulish(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _dismissTimerDialog() async {
    await DictionaryInteractor.getInstance().createWord();
    Navigator.of(context, rootNavigator: true).pop();
  }

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
