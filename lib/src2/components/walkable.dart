import '../engine/tile.dart';
import 'component.dart';
class WalkableComponent extends Component<Tile> {
  WalkableComponent(Tile parent) : super(parent);

  @override
  void update() {
    // Logic if any; might be passive
  }
}