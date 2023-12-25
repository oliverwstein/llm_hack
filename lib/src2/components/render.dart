import 'component.dart';

import '../engine/tile.dart';
import '../engine/actor.dart'; // Assuming Tile class is defined

class RenderTile extends Component<Tile> {
  String appearance; // Visual representation
  int layer; // Rendering layer

  RenderTile(Tile parent, this.appearance, this.layer) : super(parent);

  @override
  void update({String? newAppearance}) {
    if (newAppearance != null) {
      appearance = newAppearance; // Update appearance if new character is given
    }
    // Do nothing if no new character is provided
  }
}

class RenderActor extends Component<Actor> {
  String appearance; // Visual representation
  int layer; // Rendering layer

  RenderActor(Actor parent, this.appearance, this.layer) : super(parent);

  @override
  void update({String? newAppearance}) {
    if (newAppearance != null) {
      appearance = newAppearance; // Update appearance if new character is given
    }
    // Do nothing if no new character is provided
  }
}