abstract class Entity {
  String name;
  int health;
  int attack_p;
  int defense_p;

  Entity(this.name, this.health, this.attack_p, this.defense_p);

  void attack(Entity entity) {
    entity.health -= attack_p;
    print('$name이(가) ${entity.name}에게 $attack_p 데미지를 입혔습니다.');

    if (entity.health < 0) entity.health = 0;
  }

  void defend(int damage) {
    health += damage;
    print('$name이(가) 방어하여 체력 $damage 회복!');
  }

  // 캐릭터 현재 상태
  void showState() {
    print('\n[$name] 체력 :$health, 공격력 :$attack_p 방어력 :$defense_p');
  }
}
