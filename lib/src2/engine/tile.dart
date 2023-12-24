import '../components/components.dart';
import 'package:piecemeal/piecemeal.dart';
import 'actor.dart';

class Tile {
  List<Component<Tile>> components = [];
  List<Actor> actors = []; // Actors currently on this tile

  void addComponent(Component<Tile> component) {
    components.add(component);
  }

  T getComponent<T extends Component<Tile>>() {
    return components.firstWhere((c) => c is T) as T;
  }

  void removeComponent<T extends Component<Tile>>() {
    components.removeWhere((c) => c is T);
  }

  void update() {
    for (var component in components) {
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

  // Utility methods to check for walkability and transparency
  bool get isWalkable {
    return components.any((component) => component is WalkableComponent);
  }

}
