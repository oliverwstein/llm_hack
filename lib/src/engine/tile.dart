import '../components/components.dart';
import 'actor.dart';

class Tile {
  Map<Type, Component<Tile>> components = {};
  List<Actor> actors = []; // Actors currently on this tile

  // Add a component to this tile
  void addComponent(Component<Tile> component) {
    components[component.runtimeType] = component;
  }

  // Get a specific type of component from this tile
  T? getComponent<T extends Component<dynamic>>({T? defaultValue}) {
    return components[T] as T? ?? defaultValue;
  }

  // Remove a specific type of component from this tile
  void removeComponent<T extends Component<Tile>>() {
    components.remove(T);
  }

  // Update all components
  void update() {
    for (var component in components.values) {
      component.update();
    }
  }

  // Add an actor to this tile
  void addActor(Actor actor) {
    actors.add(actor);
  }

  // Remove an actor from this tile
  void removeActor(Actor actor) {
    actors.remove(actor);
  }

  // Check if the tile is occupied by any actor
  bool get isOccupied {
    return actors.isNotEmpty;
  }

  // Check for walkability based on the presence of a WalkableComponent
  bool get isWalkable {
    return components.containsKey(WalkableComponent);
  }
}
