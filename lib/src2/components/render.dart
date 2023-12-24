import 'component.dart';
abstract class Renderable {
  RenderComponent get renderComponent;
}

class RenderComponent extends Component<Renderable> {
  String appearance;
  int layer;

  RenderComponent(Renderable parent, this.appearance, this.layer) : super(parent);

  @override
  void update({String? newAppearance}) {
    if (newAppearance != null) {
      appearance = newAppearance;
    }
    // Include other update logic here as needed
  }
}
