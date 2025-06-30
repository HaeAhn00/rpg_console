import 'package:rpg_console/monster.dart';

class Character {
  // 캐릭터 클래스 안에 속성
  String name;
  int health;
  int attack_P;
  int defense_p;

  Character(this.name, this.health, this.attack_P, this.defense_p);

  // 공격 메서드
  void attackMonster(Monster monster) {
    monster.health -= attack_P;
    print('$name이(가) ${monster.name}에게 $attack_P 데미지를 입혔습니다.');

    if (monster.health < 0) monster.health = 0;
  }

  void defend(int damage) {
    health += damage;
    print('$name이(가) 방어하여 체력 $damage 회복!');
  }

  void showState() {
    print('[$name] 체력 :$health, 공격력 :$attack_P 방어력 :$defense_p');
  }
}
