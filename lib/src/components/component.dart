abstract class Component<T> {
  T parent;

  Component(this.parent);
  

  void update();
}