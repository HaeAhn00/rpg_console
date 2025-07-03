import 'dart:io';
import 'dart:math';

import 'package:rpg_console/character.dart';
import 'package:rpg_console/monster.dart';

class Game {
  Character character;
  List<Monster> monsterList;
  late Monster hiddenBoss;
  bool bossMode = false;

  int killcount = 0;
  late int totalMonsters = monsterList.length;

  Game(this.character, this.monsterList);

  final Random _random = Random();

  // 게임 시작 메서드
  void startGame() {
    print('Game Start!');

    // 30% 확률로 보너스 체력
    double chance = _random.nextDouble();
    if (chance < 0.3) {
      character.health += 10;
      print('😎 보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }

    character.showState(); // 캐릭터 상태 출력

    while (character.health > 0 && killcount < totalMonsters) {
      Monster monster = getRandomMonster();

      // 몬스터 등장 두둥탁!
      print('\n몬스터 : ${monster.name} 등장 !!');
      printMonsterAsciiArt(monster.name);
      print('"${monster.battleCry}"');

      // 전투 시작
      battle(monster);

      // 패배 처리
      if (character.health <= 0) {
        print('체력이 0.. GG..');
        askToSave('패배');
        return;
      }

      killcount++;
      print('${monster.name} 처치 완료!! ${killcount}/${totalMonsters}');

      // 히든 보스 도전 여부
      if (killcount == totalMonsters && !bossMode) {
        while (true) {
          stdout.write('\n⚔️ 히든 보스와 싸우시겠습니까? (y/n): ');
          String? answer = stdin.readLineSync()?.toLowerCase();

          if (answer == 'y') {
            // 히든 보스 로드 50% 확률로 선택됨
            List<Monster> bossList = Monster.loadBossesFromFile();
            hiddenBoss = bossList[Random().nextInt(bossList.length)];

            monsterList.add(hiddenBoss);
            totalMonsters += 1;
            bossMode = true;

            print('\n🌑 히든 보스 ${hiddenBoss.name} 등장!');
            printMonsterAsciiArt(hiddenBoss.name, isBoss: true);
            print('"${hiddenBoss.battleCry}"');

            battle(hiddenBoss);
            killcount++;

            bool survived = battle(hiddenBoss);
            if (!survived) {
              print('\n🩸 히든 보스에게 패배했습니다...');
              askToSave('패배');
              return;
            }
            // 히든 보스 승리 처리
            killcount++;
            print('\n🎉 히든 보스 ${hiddenBoss.name} 처치! 완벽한 승리입니다!\n');
            askToSave('히든보스 격파');
            return;
          } else if (answer == 'n') {
            print('\n게임 종료!');
            askToSave('게임 클리어..?');
            return;
          } else {
            print('y 또는 n만 입력해주세요!!');
          }
        }
      }

      // 다음 몬스터와 대결할지 묻기
      while (true) {
        stdout.write('\n다음 몬스터와 대결하시겠습니까? (y/n) : ');
        String? answer = stdin.readLineSync()?.toLowerCase();

        if (answer == 'y')
          break;
        else if (answer == 'n') {
          print('게임 종료');
          askToSave('중도 종료');
          return;
        } else {
          print('y 또는 n만 입력해주세요!!');
        }
      }
    }
  }

  // 전투 메서드
  bool battle(Monster monster) {
    // 각성 초기화
    character.hasAwakened = false;
    character.awakenedTurns = 0;

    bool isFirstTurn = true;

    // 전투 루프
    while (character.health > 0 && monster.health > 0) {
      if (!isFirstTurn) {
        printMonsterAsciiArt(monster.name);
        print('"${monster.battleCry}"');
      }
      isFirstTurn = false; // 첫 턴 이후부터는 출력됨

      character.showState();
      monster.showState();
      print(
          '--------------------------------------------------------------------');

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

    return character.health > 0;
  }

  // 랜덤 몬스터
  Monster getRandomMonster() {
    return monsterList[Random().nextInt(monsterList.length)];
  }

  // 게임 결과 저장
  void saveResult(String result, Character character) {
    final file = File('result.txt');
    final content =
        '캐릭터 이름: ${character.name}\n남은 체력: ${character.health}\n게임 결과: $result\n';
    file.writeAsStringSync(content);
    print('결과가 result.txt에 저장되었습니다.');
  }

  // 결과 저장 여부 묻기
  void askToSave(String result) {
    while (true) {
      stdout.write('용사님 결과를 저장하시겠습니까? (y/n) : ');
      String? saveAnswer = stdin.readLineSync()?.toLowerCase();

      if (saveAnswer == 'y') {
        saveResult(result, character);
        break;
      } else if (saveAnswer == 'n') {
        print('저장하지 않고 종료합니다.');
        break;
      } else {
        print('y 또는 n만 입력해주세요!!');
      }
    }
  }

  // 이름-파일 매핑 딕셔너리
  Map<String, String> asciiMap = {
    '안귀엽소린': 'sorin.txt',
    '뽀뽀상록': 'sangrok.txt',
    '귀엽서연': 'seoyeon.txt',
    '허스키비디오': 'vidio.txt',
    '트랄라현수': 'hyeonsu.txt',
    '도현짱': 'dohyeon.txt',
    '에리얼가람': 'garam.txt',
  };

  // 히든 보스용 도트 파일 매핑
  Map<String, String> bossAsciiMap = {
    'EZ_No.1': 'EZ_1.txt',
    '쌉T': 'ssap_T.txt',
  };

  // 도트 아트 출력 함수
  void printMonsterAsciiArt(String monsterName, {bool isBoss = false}) {
    try {
      String? filename = asciiMap[monsterName] ?? bossAsciiMap[monsterName];
      // final map = isBoss ? bossAsciiMap : asciiMap;
      // final filename = map[monsterName];
      if (filename == null) {
        print('(⚠️ 도트 파일 없음)');
        return;
      }

      final file = File('../assets/$filename');
      final art = file.readAsStringSync();
      print(art);
    } catch (e) {
      print('❌ 몬스터 도트 파일을 불러올 수 없습니다: $e');
    }
  }
}
