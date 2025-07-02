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
    print('Game Start!');
    character.showState();

    while (character.health > 0 && killcount < totalMonsters) {
      Monster monster = getRandomMonster();
      print('\n새로운 몬스터가 등장 !!');
      monster.showState();
      // print('\n');

      battle(monster);

      if (character.health <= 0) {
        print('체력이 0! GG~!');
        while (true) {
          stdout.write('용사님 결과를 저장하시겠습니까? (y/n) : ');
          String? saveAnswer = stdin.readLineSync()?.toLowerCase();

          if (saveAnswer == 'y') {
            saveResult("패배", character);
            break;
          } else if (saveAnswer == 'n') {
            print('저장하지 않고 종료합니다.');
            break;
          } else {
            print('y 또는 n만 입력해주세요!!');
          }
        }
        return;
      }

      killcount++;
      print('${monster.name} 처치 완료!! ${killcount}/${totalMonsters}');

      if (killcount == totalMonsters) {
        print('모든 몬스터 처지 완료! Game Clear!');
        return;
      }

      while (true) {
        stdout.write('\n다음 몬스터와 대결하시겠습니까? (y/n) : ');
        String? answer = stdin.readLineSync()?.toLowerCase();

        if (answer == 'y') {
          break; // 다음 전투로 진행
        } else if (answer == 'n') {
          print('게임 종료');
          while (true) {
            stdout.write('용사님 결과를 저장하시겠습니까? (y/n) : ');
            String? saveAnswer = stdin.readLineSync()?.toLowerCase();
            //  toLowerCase 대소문자 구분 없이 처리

            if (saveAnswer == 'y') {
              saveResult("중도 종료", character);
              break;
            } else if (saveAnswer == 'n') {
              print('저장하지 않고 종료합니다.');
              break;
            } else {
              print('y 또는 n만 입력해주세요!!');
            }
          }
          return; // 게임 루프 종료
        } else {
          print('y 또는 n만 입력해주세요!!');
        }
      }
    }
  }

  void battle(Monster monster) {
    while (character.health > 0 && monster.health > 0) {
      character.showState();
      monster.showState();

      // print('행동을 선택하세요: (1) 공격하기  (2) 방어하기');
      stdout.write('\n행동을 선택하세요: ( (1) 공격하기  (2) 방어하기 ) 선택: ');
      String? input = stdin.readLineSync();

      bool defended = false;

      switch (input) {
        case '1':
          character.attack(monster);
          break;
        case '2':
          character.defend(monster);
          defended = true;
          break;
        default:
          print('잘못된 입력입니다. 다시 입력 해주세요');
          continue;
      }

      if (!defended && monster.health > 0) {
        monster.attack(character);
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
