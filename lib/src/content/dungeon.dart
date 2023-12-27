import '../engine/stage.dart';
import '../engine/tile.dart';
import '../content/room.dart';
import 'package:piecemeal/piecemeal.dart';
import '../components/components.dart';
import '../content/tile_appearances.dart';
import '../utils/union_find.dart';
import '../engine/stage_builder.dart';

class Dungeon extends StageBuilder {
  List<Room> rooms = [];
  late Array2D<int> _regions;  // Mark as late
  int _currentRegion = 0;

  Dungeon(Stage stage) : super(stage) {
    // Initialize _regions here in the constructor
    _regions = Array2D<int>(stage.width, stage.height, _currentRegion);
    // Other initialization code...
  }
  
  @override
  void buildStage() {
    fill();
    addRandomRooms(60);
    makeMaze(75);
    connectRegions();
  }

  void makeMaze(int windingPercent) {
    for (var y = 1; y < stage.height; y += 2) {
      for (var x = 1; x < stage.width; x += 2) {
        var pos = new Vec(x, y);
        // If pos is a stone tile:
        if (stage.getTile(pos).getComponent<StoneComponent>() != null) {
          if (x < stage.width - 1 && y < stage.height - 1){
            _growMaze(pos, windingPercent);
          }
        }
      }
    }
  }

  void _growMaze(Vec start, int windingPercent) {
    var cells = <Vec>[];
    var lastDir;

    _currentRegion++;
    _carve(start, 'corridor', true);
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

        _carve(cell + dir, 'corridor', true);
        _carve(cell + dir * 2, 'corridor', true);

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

  void connectRegions() {
    // Identify all potential connectors and their adjacent regions
    Map<Vec, List<int>> candidates = {};
    for (int y = 1; y < stage.height - 1; y++) {
        for (int x = 1; x < stage.width - 1; x++) {
            Vec pos = Vec(x, y);
            if (_isStone(pos)) {
                List<int> adjRegions = getAdjRegions(pos);
                if (adjRegions.length >= 2) {
                    candidates[pos] = adjRegions;
                }
            }
        }
    }
    List<MapEntry<Vec, List<int>>> allEdges = candidates.entries.toList();
    UnionFind forest = UnionFind(_currentRegion + 1);  // Assuming UnionFind is implemented

    // Step 4: Process each edge
    for (var edge in allEdges) {
        Vec connector = edge.key;
        List<int> regions = edge.value;

        // Get the sets (trees) that the regions belong to
        int set1 = forest.find(regions[0]);
        int set2 = forest.find(regions[1]);

        // If they are in different sets, no cycle will be formed
        if (set1 != set2) {
            // Add this edge to the MST
            _carve(connector, 'door', true);  // Convert the connector to a passage

            // Merge the sets
            forest.union(set1, set2);
        }
        // Optionally, add extra doors or passages
        if (rng.oneIn(50)) {
            _carve(connector, 'door', true);
        }
    }
}


  List<int> getAdjRegions(Vec pos){
    List<int> adjRegions = [];
    for (var dir in Direction.cardinal) {
      Vec adjacentPos = Vec(pos.x + dir.x, pos.y + dir.y);
      if (_isInBounds(adjacentPos)) {
        adjRegions.add(_regions[adjacentPos]);
      }
    }
    return adjRegions;
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
    return pos.x >= 1 && pos.x < stage.width - 1 && pos.y >= 1 && pos.y < stage.height - 1;
  }

  bool _isStone(Vec pos) {
    Tile tile = stage.getTile(pos);
    var stoneComponent = tile.getComponent<StoneComponent>();
    return stoneComponent != null;
  }

  @override
  void _carve(Vec pos, String appearance, bool walkable) {
      var tile = stage.getTile(pos);
      tile.removeComponent<RenderTile>();
      tile.removeComponent<StoneComponent>();
      tile.addComponent(RenderTile(tile, tileAppearances[appearance]!, 0));
      if (walkable){tile.addComponent(WalkableComponent(tile));}
      _regions[pos] = _currentRegion;
  }

  void addRandomRooms(int numRoomTries) {
    for (int i = 0; i < numRoomTries; i++) {
      Room room = generateRandomRoom();
      if (!doesOverlap(room)) {
        _currentRegion++;
        carveRoom(room);
        rooms.add(room);
      }
    }
  }

  bool doesOverlap(Room newRoom) {
    for (Room room in rooms) {
      if (newRoom.overlaps(room, 0)) {
        return true;
      }
    }
    return false;
  }

  Room generateRandomRoom() {
    var size = rng.range(1, 3) * 2 + 1;
      var rectangularity = rng.range(0, 1 + size ~/ 2) * 2;
      var width = size;
      var height = size;
      if (rng.oneIn(2)) {
        width += rectangularity;
      } else {
        height += rectangularity;
      }

      var x = rng.range((stage.width - width) ~/ 2) * 2 + 1;
      var y = rng.range((stage.height - height) ~/ 2) * 2 + 1;

    return Room(x, y, width, height);
  }

  void carveRoom(Room room) {
    // Iterate over the room and its perimeter in one set of loops
    for (int y = room.y; y < room.y + room.height; y++) {
        for (int x = room.x; x < room.x + room.width; x++) {
          _carve(Vec(x, y), 'floor', true);
        }
    }
  }
}