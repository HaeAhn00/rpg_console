import 'package:rpg_console/character.dart';
import 'package:rpg_console/game.dart';
import 'package:rpg_console/monster.dart';
// import 'dart:io';

void main() {
  // 캐릭터 정보 불러오기
  Character character = Character.loadCharacterStats();

  // 몬스터 리스트 불러오기
  List<Monster> monsters = Monster.loadMonstersFromFile();

  // 게임 시작
  Game game = Game(character, monsters);
  game.startGame();
}
