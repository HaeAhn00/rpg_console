import 'dart:math';
import 'package:rpg_console/character.dart';

class Monster {
  String name;
  int health;
  int attack_Max_p;
  int attack_p;
  int defense_p = 0;

  Monster(this.name, this.health, this.attack_Max_p, this.attack_p,
      this.defense_p) {
    attack_p = (defense_p > attack_Max_p)
        ? defense_p
        : Random().nextInt(attack_Max_p) + 1;
  }

  // 캐릭터 공격 메서드
  void attackCharacter(Character character) {
    int damage = attack_p - character.defense_p;
    if (damage < 0) damage = 0;

    character.health -= damage;
    if (character.health < 0) character.health = 0;

    print('$name이(가) ${character.name}에게 $damage 데미지를 입혔습니다.');
  }

  void showStatus() {
    print('[$name] 체력 :$health, 공격력 :$attack_p');
  }
}
