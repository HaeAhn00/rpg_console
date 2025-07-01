import 'dart:math';
import 'dart:io';
// import 'package:rpg_console/character.dart';
import 'package:rpg_console/entity.dart';

class Monster extends Entity {
  Monster(String name, int health, int attack_Max_p, int defense_p)
      : super(name, health, Random().nextInt(attack_Max_p) + 1, defense_p);

  // txt 파일에서 몬스터 불러오기
  static List<Monster> loadMonstersFromFile() {
    try {
      final file = File('../assets/monsters.txt');
      final lines = file.readAsLinesSync();

      return lines.map((line) {
        final parts = line.split(',');
        if (parts.length != 3)
          throw FormatException('Invalid monster data: $line');

        String name = parts[0].trim();
        int health = int.parse(parts[1].trim());
        int attackMax = int.parse(parts[2].trim());

        return Monster(name, health, attackMax, 0);
      }).toList();
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }
}
