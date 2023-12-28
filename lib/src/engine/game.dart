// Assuming Actor.dart and Tile.dart are imported
import 'actor.dart';
import 'event.dart';
import 'tile.dart';
import 'stage.dart';
import 'package:piecemeal/piecemeal.dart';

class Game {
  late Stage stage; // Declare stage, but initialize it later
  Actor? player; // The player actor, if any

  bool isRunning;

  // Constructor
  Game() : isRunning = true;

  // Initialize or load the game world
  void initializeWorld() {
    // Initialize the stage within the constructor body
    stage = Stage(51, 31, this);
  }

  // The main game loop
  void run() {
    initializeWorld();
    while (isRunning) { // Continue while the game is active
      update();
      handleInput(); // Method to handle player input and possibly AI
      checkEndConditions(); // Check if the game should end
      isRunning = false;
      if (stage.actors.isEmpty && stage.tiles.isEmpty) {
        isRunning = false;
      }
    }
  }

  // Update the game state
  void update() {
    for (Actor actor in stage.actors) {
      actor.update(); // Update each actor
    }
    for (Tile tile in stage.tiles) {
      tile.update(); // Directly iterate over individual tiles
    }
  }

  // Method to get a tile at a specified position
  Tile getTileAt(Vec pos) {
  // Check if the coordinates are within the bounds of the stage
  if (stage.bounds.contains(pos)) {
    return stage.tiles[pos]; // Directly access the tile using Array2D's indexing
  } else {
    // Position is out of bounds
    throw RangeError('Position is out of stage bounds.'); // Or handle it as you see fit
  }
}

  // Stub method for handling input
  void handleInput() {
    // Handle player input if there is a player
    if (player != null) {
      // Input handling logic
    }
    // Possibly handle AI for non-player actors here or within their update method
  }

  // Check and handle ending conditions
  void checkEndConditions() {
    // Define your game-specific ending conditions here
    // For example, check if a certain goal has been achieved, or if all actors are inactive or dead
    // If there is a player, you might still want to check their status
    // if (player != null && !player.isAlive) {
    //   isRunning = false; // Stop the game if the player died
    // }
  }
}

/// Each call to [Game.update()] will return a [GameResult] object that tells
  /// the UI what happened during that update and what it needs to do.
  class GameResult {
    /// The "interesting" events that occurred in this update.
    final List<Event> events;

    /// Whether or not any game state has changed. If this is `false`, then no
    /// game processing has occurred (i.e. the game is stuck waiting for user
    /// input for the [Hero]).
    bool madeProgress = false;

    /// Returns `true` if the game state has progressed to the point that a change
    /// should be shown to the user.
    bool get needsRefresh => madeProgress || events.isNotEmpty;

    GameResult()
    : events = <Event>[];
  }

