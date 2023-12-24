import '../engine/actor.dart';
import 'component.dart';
class HealthComponent extends Component<Actor> {
  int health;
  int maxHealth;

  HealthComponent(Actor actor, this.health, this.maxHealth) : super(actor);

  @override
  void update() {
    // Include any regeneration or ongoing damage logic here
  }

  // Reduce health by the given amount
  void takeDamage(int amount) {
    health -= amount;
    health = health.clamp(0, maxHealth);
  }

  // Increase health by the given amount
  void heal(int amount) {
    health += amount;
    health = health.clamp(0, maxHealth);
  }

  // Check if the actor is alive based on health
  bool isAlive() {
    return health > 0;
  }
}