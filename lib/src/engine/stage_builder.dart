import 'dart:math';
import '../engine/stage.dart';
import '../engine/tile.dart';
import '../components/components.dart';
import 'package:piecemeal/piecemeal.dart';
import '../content/tile_appearances.dart';

abstract class StageBuilder {
  final Stage stage;
  Random rand = Random();

  StageBuilder(this.stage);

  // Method to build the stage
  void buildStage(){
  }

  void fill() {
    for (var y = 0; y < stage.height; y++) {
      for (var x = 0; x < stage.width; x++) {
        Tile tile = Tile();
        tile.addComponent(StoneComponent(tile));
        tile.addComponent(RenderTile(tile, tileAppearances['stone']!, 0));
        stage.setTile(Vec(x, y), tile);
      }
    }
  }

  void _carve(Vec pos, String appearance, bool walkable) {
  }
}