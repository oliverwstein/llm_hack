// Assuming Actor.dart and Tile.dart are imported
import 'actor.dart';
import 'tile.dart';
import 'stage.dart';
import 'package:piecemeal/piecemeal.dart';

class Game {
  late Stage stage; // Declare stage, but initialize it later
  List<Actor> actors; // All actors in the game
  Actor? player; // The player actor, if any

  bool isRunning;

  // Constructor
  Game() : actors = [], isRunning = true {
    // Initialize the stage within the constructor body
    stage = Stage(10, 10, this); // 'this' is valid here
    initializeWorld();
  }

  // Initialize or load the game world
  void initializeWorld() {
    // Load or create tiles and place actors
    // ... existing initialization code

    // Initialize the player, if necessary, and other actors
    // player = Actor(this, Vec(5, 5), 100, 100); // Example initialization
    // actors.add(player); // Add player to actors list if there is one
    // Add other actors as needed
  }

  // The main game loop
  void run() {
    while (isRunning) { // Continue while the game is active
      update();
      handleInput(); // Method to handle player input and possibly AI
      checkEndConditions(); // Check if the game should end
      
      // Additional check to avoid tight loop in case there is no player or actors
      if (actors.isEmpty) {
        isRunning = false;
      }
    }
  }

  // Update the game state
  void update() {
    for (Actor actor in actors) {
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
