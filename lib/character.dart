import 'dart:convert';
import 'dart:io';
import 'package:rpg_console/entity.dart';
// import 'package:rpg_console/monster.dart';

class Character extends Entity {
  Character(super.name, super.health, super.attack_p, super.defense_p);

  // 캐릭터 이름 입력
  static getCharacterName() {
    final nameReg = RegExp(r'^[a-zA-Z가-힣]+$');

    while (true) {
      stdout.write('캐릭터 이름을 입력하세요 (한글/영문): ');
      String? input = stdin.readLineSync(encoding: utf8); // UTF-8

      if (input != null && nameReg.hasMatch(input.trim())) {
        return input.trim();
      } else {
        print('❌ 유효하지 않은 이름입니다. 다시 입력해주세요.');
      }
    }
  }

  // 텍스트 파일에서 캐릭터 스텟 불러오기, 사용자 이름과 함께 캐릭터 객체 생성
  static Character loadCharacterStats() {
    try {
      final file = File('../assets/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid character data');

      int health = int.parse(stats[0]);
      int attack_p = int.parse(stats[1]);
      int defense_p = int.parse(stats[2]);

      String name = Character.getCharacterName();
      return Character(name, health, attack_p, defense_p);
    } catch (e) {
      print('❌ 캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  int awakenedTurns = 0;
  bool hasAwakened = false;

  void awaken() {
    if (hasAwakened) {
      print('\n이미 각성했습니다. 이 힘은 두 번 쓸 수 없다...');
    } else {
      awakenedTurns = 2;
      hasAwakened = true;
      print('\n이제 슬슬 제대로 해볼까?');
      print('$name이(가) 각성했다!💪 2턴 동안 데미지 2배 & 몬스터는 공격 불가');
    }
  }

  @override
  void attack(Entity entity) {
    int effectiveAttack = awakenedTurns > 0 ? attack_p * 2 : attack_p;
    int damage = effectiveAttack - entity.defense_p;
    if (damage < 1) damage = 1;

    entity.health -= damage;
    if (entity.health < 0) entity.health = 0;

    print('$name이(가) ${entity.name}에게 $damage 데미지를 입혔습니다.');

    if (awakenedTurns > 0) awakenedTurns--;
  }
}
