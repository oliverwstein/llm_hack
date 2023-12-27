import 'stage.dart';
import 'tile.dart';
import '../content/room.dart';
import 'package:piecemeal/piecemeal.dart';
import '../components/components.dart';
import 'dart:math';
import '../content/tile_appearances.dart';


class StageBuilder {
  final Stage stage;
  final List<Room> rooms = []; // Keep track of rooms on the stage
  Random rand = Random();
  int _currentRegion = 0;

  StageBuilder(this.stage) {
    fillWithStone(); // Fill the stage with stone walls initially
    int numRoomTries = 100; // Number of attempts to place rooms, adjust as needed
    addRandomRooms(numRoomTries);
    makeMaze(50);
  }

  void buildSimpleLayout() {
    for (int y = 0; y < stage.height; y++) {
      for (int x = 0; x < stage.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));

        if (x == 0 || y == 0 || x == stage.width - 1 || y == stage.height - 1) {
          // Assign wall appearance
          tile.addComponent(RenderTile(tile, tileAppearances['wall']!, 0));
          // Walls do NOT have the WalkableComponent
        } else {
          // Assign floor appearance and make it walkable
          tile.addComponent(RenderTile(tile, tileAppearances['floor']!, 0));
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
        tile.addComponent(RenderTile(tile, tileAppearances['stone']!, 0));
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
    // Loop over every tile in the room including the edges
    for (int y = room.y; y < room.y + room.height; y++) {
      for (int x = room.x; x < room.x + room.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));

        // Check if the tile is on the edge of the room
        bool isEdge = x == room.x || y == room.y || x == room.x + room.width - 1 || y == room.y + room.height - 1;

        if (isEdge) {
          tile.removeComponent<RenderTile>();
          tile.addComponent(RenderTile(tile, tileAppearances['wall']!, 0)); // Add wall component
        } else {
          // This is an inner tile, so carve it as floor
          tile.removeComponent<RenderTile>();
          tile.addComponent(RenderTile(tile, tileAppearances['floor']!, 0)); // Add floor component
          tile.addComponent(WalkableComponent(tile)); // Make the tile walkable
        }
      }
    }
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
      if (newRoom.overlaps(room, 1)) {
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
        tile.addComponent(RenderTile(tile, tileAppearances['floor']!, 0));
        tile.addComponent(WalkableComponent(tile));
      }
    }
  }

  void makeMaze(int windingPercent) {
    // Fill in all of the empty space with mazes.
    for (var y = 1; y < stage.height; y += 2) {
        for (var x = 1; x < stage.width; x += 2) {
            var pos = Vec(x, y);
            var tile = stage.getTile(pos);
            var renderTile = tile.getComponent<RenderTile>();
            
            if (renderTile?.appearance != tileAppearances['stone']!) continue;
            _growMaze(pos, 50);
        }
    }
  }

  void _growMaze(Vec start, int windingPercent) {
    var cells = <Vec>[];
    var lastDir;

    _startRegion();
    _carve(start);

    cells.add(start);
    while (cells.isNotEmpty) {
      var cell = cells.last;

      // See which adjacent cells are open.
      var unmadeCells = <Direction>[];

      for (var dir in Direction.cardinal) {
        if (_canCarve(cell, dir)) unmadeCells.add(dir);
      }

      if (unmadeCells.isNotEmpty) {
        // Based on how "windy" passages are, try to prefer carving in the
        // same direction.
        var dir;
        if (unmadeCells.contains(lastDir) && rng.range(100) > windingPercent) {
          dir = lastDir;
        } else {
          dir = rng.item(unmadeCells);
        }

        _carve(cell + dir);
        _carve(cell + dir * 2);

        cells.add(cell + dir * 2);
        lastDir = dir;
      } else {
        // No adjacent uncarved cells.
        cells.removeLast();

        // This path has ended.
        lastDir = null;
      }
    }
  }

  bool _canCarve(Vec cell, Direction dir) {
  // Calculate the new position after moving in the given direction
  Vec newPos = Vec(cell.x + dir.x, cell.y + dir.y);

  // Ensure that newPos is within the stage boundaries
  if (!_isInBounds(newPos)) return false;

  // Check the cell two steps ahead in the same direction to prevent carving into adjacent passages
  Vec ahead = Vec(newPos.x + dir.x, newPos.y + dir.y);
  if (!_isInBounds(ahead) || !_isStone(ahead)) return false;

  // Check if the new position is currently a wall and can be carved
  return _isStone(newPos);
}

bool _isInBounds(Vec pos) {
  // Ensure the position is within the stage boundaries
  return pos.x >= 0 && pos.x < stage.width && pos.y >= 0 && pos.y < stage.height;
}

bool _isStone(Vec pos) {
  // Check if the tile at the given position is a wall, by checking its appearance or type
  Tile tile = stage.getTile(pos);
  var renderTile = tile.getComponent<RenderTile>(); // Assuming getComponent method is available
  return renderTile?.appearance == tileAppearances['stone']!; // Wall character
}


  void _carve(Vec pos) {
  var tile = stage.getTile(pos);
  tile.removeComponent<RenderTile>(); // Remove the wall component
  tile.addComponent(RenderTile(tile, tileAppearances['floor']!, 0)); // Add floor component
  tile.addComponent(WalkableComponent(tile)); // Make it walkable
}

  void _startRegion() {
    _currentRegion++; // Increment to signify a new region
    // Additional logic to mark the start of a new region...
  }



  
}
