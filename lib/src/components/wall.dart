import '../engine/tile.dart';
import 'component.dart';
class WallComponent extends Component<Tile> {
  WallComponent(Tile parent) : super(parent);

  @override
  void update() {
    // Logic if any; might be passive
  }
}