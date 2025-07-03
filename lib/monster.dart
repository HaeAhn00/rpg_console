import 'dart:math';
import 'dart:io';
// import 'package:rpg_console/character.dart';
import 'package:rpg_console/entity.dart';

// 몬스터 클래스 - Entity 추상 클래스를 상속
class Monster extends Entity {
  final String battleCry; // 등장 대사

  // 생성자: 공격력은 attack_Max_p까지의 랜덤값으로 지정
  Monster(
      String name, int health, int attack_Max_p, int defense_p, this.battleCry)
      : super(name, health, Random().nextInt(attack_Max_p) + 1, defense_p);

  // txt 파일에서 몬스터 불러오기
  static List<Monster> loadMonstersFromFile() {
    try {
      final file = File('../assets/monsters.txt');
      final lines = file.readAsLinesSync();

      return lines.map((line) {
        final parts = line.split(',');
        if (parts.length != 4)
          throw FormatException('Invalid monster data: $line');

        String name = parts[0].trim();
        int health = int.parse(parts[1].trim());
        int attackMax = int.parse(parts[2].trim());
        String battleCry = parts[3].trim();

        return Monster(name, health, attackMax, 0, battleCry);
      }).toList();
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 히든 보스
  static List<Monster> loadBossesFromFile() {
    try {
      final file = File('../assets/bosses.txt');
      final lines = file.readAsLinesSync();

      return lines.map((line) {
        final parts = line.split(',');
        if (parts.length != 4)
          throw FormatException('Invalid boss data: $line');

        String name = parts[0].trim();
        int health = int.parse(parts[1].trim());
        int attackMax = int.parse(parts[2].trim());
        String battleCry = parts[3].trim();

        return Monster(name, health, attackMax, 0, battleCry);
      }).toList();
    } catch (e) {
      print('보스 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  int turnCount = 0; // 몬스터가 받은 공격 턴 수 추적

  void increaseDefense() {
    turnCount++;
    if (turnCount % 3 == 0) {
      defense_p += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense_p');
      turnCount = 0;
    }
  }
}
