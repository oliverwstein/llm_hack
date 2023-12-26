class Room {
  int x, y, width, height;

  Room(this.x, this.y, this.width, this.height);

  // Method to check if this room overlaps with another room
  bool overlaps(Room other) {
    return x < other.x + other.width &&
           x + width > other.x &&
           y < other.y + other.height &&
           y + height > other.y;
  }
}