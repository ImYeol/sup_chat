import 'package:flutter/material.dart';

enum StatusType {
  INVALID,
  WORK,
  WORK_OFF,
  HOME,
  HOME_WORK,
  DRIVING,
  REST,
  LUNCH,
  DINNER,
  EXERCISE,
  GAME,
}

final mapStatusTypeToIcon = {
  StatusType.INVALID: Icons.insert_emoticon_outlined,
  StatusType.WORK: Icons.work_outline_outlined,
  StatusType.HOME: Icons.home_outlined,
  StatusType.HOME_WORK: Icons.home_work_outlined,
  StatusType.WORK_OFF: Icons.work_off_outlined,
  StatusType.REST: Icons.do_not_disturb,
  StatusType.DRIVING: Icons.drive_eta_outlined,
  StatusType.LUNCH: Icons.lunch_dining_outlined,
  StatusType.DINNER: Icons.dining_outlined,
  StatusType.EXERCISE: Icons.sports_gymnastics_outlined,
  StatusType.GAME: Icons.sports_esports_outlined,
};

final mapStatusTypeToString = {
  StatusType.INVALID: "상태없음",
  StatusType.WORK: "일하는중",
  StatusType.HOME: "집",
  StatusType.HOME_WORK: "재택중",
  StatusType.WORK_OFF: "연차",
  StatusType.REST: "휴식중",
  StatusType.DRIVING: "운전중",
  StatusType.LUNCH: "점심식사",
  StatusType.DINNER: "저녁식사",
  StatusType.EXERCISE: "운동중",
  StatusType.GAME: "게임중",
};
