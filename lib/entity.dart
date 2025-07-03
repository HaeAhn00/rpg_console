import 'package:rpg_console/monster.dart';

abstract class Entity {
  String name;
  int health;
  int attack_p;
  int defense_p;

  Entity(this.name, this.health, this.attack_p, this.defense_p);

  void attack(Entity entity) {
    int damage = attack_p - entity.defense_p;
    if (damage < 1) damage = 1;

    entity.health -= damage;
    if (entity.health < 0) entity.health = 0;

    print('$name이(가) ${entity.name}에게 $damage 데미지를 입혔습니다.');

    if (entity is Monster) // entity가 monster일 경우에만 아래 호출
      entity.increaseDefense(); // ← 공격받을 때마다 턴 증가 및 방어력 체크
  }

  void defend(Entity damage) {
    // 근데 상대 공격력 - 내 방어력만큼 회복은 뭔가 조금 이상하네요..
    int sum_damage = damage.attack_p - defense_p;
    if (sum_damage < 0) sum_damage = 0;
    health += sum_damage;
    print('$name이(가) 방어하여 체력 $sum_damage 회복!');
  }

  // 캐릭터 현재 상태
  void showState() {
    print('\n[$name] 체력 :$health, 공격력 :$attack_p 방어력 :$defense_p');
  }
}
