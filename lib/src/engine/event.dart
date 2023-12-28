import 'actor.dart';
import 'package:piecemeal/piecemeal.dart';

class Event {
  final EventType type;
  final Actor actor;
  final other;
  final Vec pos;
  final Direction dir;

  Event(this.type, this.actor, this.pos, this.dir, this.other);
}

class EventType {
  final String _value;
  const EventType(this._value);
}