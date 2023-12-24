// Assuming Actor.dart and Tile.dart are imported
import 'actor.dart';
import 'tile.dart';
import 'package:piecemeal/piecemeal.dart';

class Game {
  Array2D<Stage> stage; // The grid representing the game world
  List<Actor> actors; // All actors in the game
  Actor? player; // The player actor, if any

  bool isRunning;

  // Constructor
  Game() : stage = stage, actors = [], isRunning = true {
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
    for (List<Tile> row in stage) {
      for (Tile tile in row) {
        tile.update(); // Update each tile
      }
    }
  }

  // Method to get a tile at a specified position
  Tile getTileAt(Vec pos) {
    int x = pos.x;
    int y = pos.y;

    // Check if the coordinates are within the bounds of the game world
    if (y >= 0 && y < stage.length && x >= 0 && x < stage[y].length) {
      return stage[y][x];
    } else {
      // Position is out of bounds or no tile exists at the position
      return stage[0][0]; // Return null or handle it as you see fit
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
