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

  final Random _random = Random();

  void startGame() {
    print('Game Start!');

    // 30% 확률로 보너스 체력
    double chance = _random.nextDouble();
    if (chance < 0.3) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }

    character.showState();

    while (character.health > 0 && killcount < totalMonsters) {
      Monster monster = getRandomMonster();

      // 다음 몬스터와 대결할 때 각성 초기화!!!
      // character.hasAwakened = false;
      // character.awakenedTurns = 2;

      print('\n${monster.name} 등장 !!');
      print('"${monster.battleCry}"');

      monster.showState();

      battle(monster);

      if (character.health <= 0) {
        print('체력이 0.. GG..');
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

        while (true) {
          stdout.write('용사님 결과를 저장하시겠습니까? (y/n) : ');
          String? answer = stdin.readLineSync();
          if (answer == 'y') {
            saveResult('승리', character);
            break;
          } else if (answer == 'n') {
            print('저장하지 않고 게임을 종료합니다.');
            break;
          } else {
            print('y 또는 n만 입력해주세요!!');
          }
        }

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
    character.hasAwakened = false;
    character.awakenedTurns = 0;
    while (character.health > 0 && monster.health > 0) {
      character.showState();
      monster.showState();

      stdout.write('\n행동을 선택하세요: ( (1) 공격하기  (2) 방어하기 (3) 각성 ) 선택: ');
      String? input = stdin.readLineSync();

      bool defended = false;

      switch (input) {
        case '1':
          character.attack(monster);
          monster.increaseDefense();
          break;
        case '2':
          character.defend(monster);
          monster.increaseDefense();
          defended = true;
          break;
        case '3':
          character.awaken();
          break;
        default:
          print('잘못된 입력입니다. 다시 입력 해주세요');
          continue;
      }
      // 각성 상태 & 방어 시 몬스터 공격 X
      if (!defended && monster.health > 0) {
        if (character.awakenedTurns > 0) {
          print('${character.name}의 각성 기운에 눌려 ${monster.name}이(가) 공격 불능 상태!');
        } else {
          monster.attack(character);
        }
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
