import 'dart:math';
import 'dart:io';
import 'package:rpg_console/character.dart';

class Monster {
  String name;
  int health;
  int attack_Max_p;
  int attack_p;
  int defense_p = 0;

  Monster(this.name, this.health, this.attack_Max_p)
      : attack_p = Random().nextInt(attack_Max_p) + 1;

  void showStatus() {
    print('[$name] 체력 :$health, 공격력 :$attack_p\n');
  }

  // 캐릭터 공격 메서드
  void attackCharacter(Character character) {
    int damage = attack_p - character.defense_p;
    if (damage < 0) damage = 0;

    character.health -= damage;
    if (character.health < 0) character.health = 0;

    print('$name이(가) ${character.name}에게 $damage 데미지를 입혔습니다.\n');
  }

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

        return Monster(name, health, attackMax);
      }).toList();
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }
}
