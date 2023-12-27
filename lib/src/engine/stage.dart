import 'package:piecemeal/piecemeal.dart';
import 'game.dart';
import 'tile.dart';
import 'actor.dart';
import 'stage_builder.dart';
import '../content/dungeon.dart';

class Stage {
  final Game game;
  final Array2D<Tile> tiles;
  final Array2D<Actor?> _actorsByTile;
  final List<Actor> _actors = <Actor>[];
  int _currentActorIndex = 0;

  Stage(int width, int height, this.game)
      : tiles = Array2D.generated(width, height, (_) => Tile()),
        _actorsByTile = Array2D(width, height, null){

        // Initialize the StageBuilder with this Stage instance
        StageBuilder builder = Dungeon(this); 
        builder.buildStage();
        // Use the builder to set up the stage's tiles
        }

  // Stage properties getters
  int get width => tiles.width;
  int get height => tiles.height;
  Rect get bounds => tiles.bounds;
  Iterable<Actor> get actors => _actors;
  Actor get currentActor => _actors[_currentActorIndex];

  // Example method to add an actor to the stage
  void addActor(Actor actor) {
    _actors.add(actor);
    // Update spatial partition for actors
    _actorsByTile[actor.pos] = actor;
    // Additional logic to place actor in the stage
  }

  // Example method to remove an actor from the stage
  void removeActor(Actor actor) {
    _actors.remove(actor);
    // Update spatial partition for actors
    _actorsByTile[actor.pos] = null;
    // Additional logic for removing actor from the stage
  }

  // Get tile at a specific position
  Tile getTile(Vec pos) {
    return tiles[pos];
  }

  // Set tile at a specific position
  void setTile(Vec pos, Tile tile) {
    tiles[pos] = tile;
  }

  // Update stage - called every game tick or turn
  void update() {
    // Update all actors
    for (var actor in _actors) {
      actor.update();
    }

    // Additional update logic as needed
  }

  // Additional stage methods as needed...
}
