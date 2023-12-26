import '../engine/tile.dart';
import 'components.dart';
import '../engine/tile.dart'; // Assuming Tile class is defined

class DoorComponent extends Component<Tile> {
  bool isOpen;

  DoorComponent(Tile parent, {this.isOpen = false}) : super(parent);

  void toggle() {
    isOpen = !isOpen;
    // Define the new appearance based on the door's new state
    String newAppearance = isOpen ? 'openDoor' : 'closedDoor';

    // Retrieve the RenderComponent and update its appearance
    var renderComponent = parent.getComponent<RenderTile>();
    renderComponent?.update(newAppearance: newAppearance);

    // Handle walkability logic as before...
  }

  @override
  void update() {
    // Handle any dynamic door behavior here
  }
}

