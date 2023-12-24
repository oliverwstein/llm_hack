import 'package:piecemeal/piecemeal.dart';
import '../components/components.dart';
import 'tile.dart'; // Your Tile class
import 'game.dart';


class Actor {
  final Game game; // Reference to the game object
  Vec pos; // Position in the game world
  List<Component<Actor>> components = []; // Components attached to this actor

  int _health; // Private health property
  int maxHealth; // Maximum health for the actor

  // Constructor
  Actor(this.game, this.pos, this._health, this.maxHealth);

  // Add a component to this actor
  void addComponent(Component<Actor> component) {
    components.add(component);
  }

  // Remove a specific type of component from this actor
  void removeComponent<T extends Component<Actor>>() {
    components.removeWhere((c) => c is T);
  }

  // Update all components (called every game tick or when needed)
  void update() {
    for (var component in components) {
      component.update();
    }
  }

  // Handling health
  int get health => _health;
  set health(int value) {
    _health = value.clamp(0, maxHealth);
    if (_health <= 0) {
      die(); // Handle actor death
    }
  }

  // Method to handle actor death
  void die() {
    // Remove from game, trigger any death events, etc.
  }

  bool isAlive() {
    // Check if the actor has a HealthComponent
    bool hasHealthComponent = components.any((component) => component is HealthComponent);

    // If it doesn't have a HealthComponent, it's not considered alive
    if (!hasHealthComponent) {
      return false;
    }

    // If it does have a HealthComponent, check if its health is above 0
    HealthComponent healthComponent = components.firstWhere((c) => c is HealthComponent) as HealthComponent;
    return healthComponent.health > 0;
  }

  // Method to handle actor movement
 bool tryMove(Vec to) {
  Tile fromTile = game.getTileAt(pos); // Tile the actor is currently on
  Tile toTile = game.getTileAt(to); // Destination tile
  
  if (toTile.isWalkable && !toTile.isOccupied) {
    fromTile.removeActor(this); // Leave the current tile
    toTile.addActor(this); // Enter the new tile
    pos = to; // Update position
    return true; // Move succeeded
  }
  return false; // Move failed
}

  // ... Additional methods for combat, interaction, etc.
}
