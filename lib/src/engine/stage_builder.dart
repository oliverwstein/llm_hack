import 'stage.dart';
import 'tile.dart';
import 'package:piecemeal/piecemeal.dart';
import '../components/components.dart';

class StageBuilder {
  final Stage stage;

  StageBuilder(this.stage);

  void buildSimpleLayout() {
    for (int y = 0; y < stage.height; y++) {
      for (int x = 0; x < stage.width; x++) {
        Tile tile = stage.getTile(Vec(x, y));

        if (x == 0 || y == 0 || x == stage.width - 1 || y == stage.height - 1) {
          // Assign wall appearance
          tile.addComponent(RenderTile(tile, '#', 0));
          // Walls do NOT have the WalkableComponent
        } else {
          // Assign floor appearance and make it walkable
          tile.addComponent(RenderTile(tile, '.', 0));
          tile.addComponent(WalkableComponent(tile));
        }
      }
    }
  }
  // ... Additional methods for more complex stage generation ...
}
