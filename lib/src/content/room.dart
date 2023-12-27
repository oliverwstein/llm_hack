class Room {
  int x, y, width, height;

  Room(this.x, this.y, this.width, this.height);

  // Method to check if this room overlaps with another room
  bool overlaps(Room other, int buffer) {
    return x < other.x + other.width + buffer &&
           x + width + buffer > other.x &&
           y < other.y + other.height + buffer &&
           y + height + buffer > other.y;
}
}