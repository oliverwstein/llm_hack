import 'stage.dart';
import 'tile.dart';
import '../content/room.dart';
import 'package:piecemeal/piecemeal.dart';
import '../components/components.dart';
import 'dart:math';


class StageBuilder {
  final Stage stage;
  final List<Room> rooms = []; // Keep track of rooms on the stage
  Random rand = Random();

  StageBuilder(this.stage) {
    fillWithStone(); // Fill the stage with stone walls initially
  }

  void buildSimpleLayout() {
    for (int y = 0; y < stage.height; y++) {
      for (int x = 0; x < stage.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));

        if (x == 0 || y == 0 || x == stage.width - 1 || y == stage.height - 1) {
          // Assign wall appearance
          tile.addComponent(RenderTile(tile, '■', 0));
          // Walls do NOT have the WalkableComponent
        } else {
          // Assign floor appearance and make it walkable
          tile.addComponent(RenderTile(tile, '.', 0));
          tile.addComponent(WalkableComponent(tile));
        }
      }
    }
  }

  void fillWithStone() {
    for (int y = 0; y < stage.height; y++) {
      for (int x = 0; x < stage.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));
        // Assign wall appearance to all tiles initially
        tile.addComponent(RenderTile(tile, '■', 0));
      }
    }
  }

  // Method to generate and place rooms
  void addRandomRooms(int numRoomTries) {
    for (int i = 0; i < numRoomTries; i++) {
      Room room = generateRandomRoom();
      if (!doesOverlap(room)) {
        carveRoom(room);
        rooms.add(room);
      }
    }
  }

  // Carve out the room by replacing wall tiles with floor tiles
  void carveRoom(Room room) {
    // Loop starts from 1 tile inward and ends 1 tile before the actual edge
    for (int y = room.y + 1; y < room.y + room.height - 1; y++) {
      for (int x = room.x + 1; x < room.x + room.width - 1; x++) {
        Tile tile = stage.getTile(Vec(x, y));
        // Replace wall with floor appearance and make it walkable
        tile.removeComponent<RenderTile>(); // Remove the wall component first
        tile.addComponent(RenderTile(tile, '.', 0)); // Add floor component
        tile.addComponent(WalkableComponent(tile));
      }
    }
    // Edge tiles remain walls, inner tiles become floors
  }

  // Generate a random room within the stage constraints
  Room generateRandomRoom() {
    int maxWidth = (stage.width / 3).floor();
    int maxHeight = (stage.height / 3).floor();

    int width = rand.nextInt(maxWidth - 2) + 4; // Ensure room is at least 4 wide
    int height = rand.nextInt(maxHeight - 2) + 4; // Ensure room is at least 4 tall
    int x = rand.nextInt(stage.width - width);
    int y = rand.nextInt(stage.height - height);

    return Room(x, y, width, height);
  }

  // Check if the room overlaps with any existing rooms
  bool doesOverlap(Room newRoom) {
    for (Room room in rooms) {
      if (newRoom.overlaps(room)) {
        return true;
      }
    }
    return false;
  }

  // Place the room on the stage
  void placeRoom(Room room) {
    for (int y = room.y; y < room.y + room.height; y++) {
      for (int x = room.x; x < room.x + room.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));
        // Assign floor appearance and make it walkable
        tile.addComponent(RenderTile(tile, '.', 0));
        tile.addComponent(WalkableComponent(tile));
      }
    }
  }
}
