import 'package:flutter/material.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/resources/resources.dart';

class CubicItem extends StatelessWidget {
  const CubicItem({required this.info, super.key});

  final LetterInfo info;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: info.letterStatus.itemColor(context),
            border: info.letterStatus == LetterStatus.unknown
                ? Border.all(
                    width: 3,
                    color: context.dynamicColor(
                      light: AppColors.dark,
                      dark: AppColors.light,
                    ),
                  )
                : null,
          ),
          child: Text(
            info.letter.toUpperCase(),
            style: context.theme.tl.copyWith(
              color: info.letterStatus == LetterStatus.unknown
                  ? null
                  : Colors.white,
            ),
          ),
        ),
      );
}