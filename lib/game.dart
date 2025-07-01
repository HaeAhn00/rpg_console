import 'dart:io';
import 'dart:math';

import 'package:rpg_console/character.dart';
import 'package:rpg_console/monster.dart';

class Game {
  Character character;
  List<Monster> monsterList;
  int killcount = 0;
  late int totalMonsters = monsterList.length;

  Game(this.character, this.monsterList);

  void startGame() {
    print('Game Start!\n');
    character.showState();

    while (character.health > 0 && killcount < totalMonsters) {
      Monster monster = getRandomMonster();
      print('\n새로운 몬스터가 등장 !!');
      monster.showStatus();

      battle(monster);

      if (character.health < 0) {
        print('체력이 0, Game Over!');
        return;
      }

      killcount++;
      print('${monster.name} 처치 완료!! ${killcount}/${totalMonsters}');

      if (killcount == totalMonsters) {
        print('모든 몬스터 처지 완료! Game Clear!');
        return;
      }

      stdout.write('\n다음 몬스터와 대결하시겠습니까? (y/n) : ');
      String? answer = stdin.readLineSync();
      if (answer == 'n') {
        print('게임 종료');
        stdout.write('용사님 결과를 저장하시겠습니까? (y/n) : ');
        String? saveAnswer = stdin.readLineSync();
        if (saveAnswer?.toLowerCase() == 'y') {
          saveResult("중도 종료", character);
        }
        return;
      }
    }
  }

  void battle(Monster monster) {
    while (character.health > 0 && monster.health > 0) {
      character.showState();
      monster.showStatus();

      // print('행동을 선택하세요: (1) 공격하기  (2) 방어하기');
      stdout.write('행동을 선택하세요: ( (1) 공격하기  (2) 방어하기) 선택: ');
      String? input = stdin.readLineSync();

      switch (input) {
        case '1':
          character.attackMonster(monster);
          break;
        case '2':
          character.defend(monster.attack_p);
          break;
        default:
          print('잘못된 입력입니다. 다시 입력 해주세요');
          continue;
      }

      if (monster.health > 0) {
        monster.attackCharacter(character);
      }
    }

    monsterList.remove(monster);
  }

  Monster getRandomMonster() {
    return monsterList[Random().nextInt(monsterList.length)];
  }

  void saveResult(String result, Character character) {
    final file = File('result.txt');
    final content =
        '캐릭터 이름: ${character.name}\n남은 체력: ${character.health}\n게임 결과: $result\n';
    file.writeAsStringSync(content);
    print('결과가 result.txt에 저장되었습니다.');
  }
}
