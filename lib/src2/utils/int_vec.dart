import 'dart:math';
class IntVec {
  int x;
  int y;

  IntVec(this.x, this.y);

  // Vector addition
  IntVec operator +(IntVec other) {
    return IntVec(x + other.x, y + other.y);
  }

  // Vector subtraction
  IntVec operator -(IntVec other) {
    return IntVec(x - other.x, y - other.y);
  }

  // Scalar multiplication
  IntVec operator *(int scalar) {
    return IntVec(x * scalar, y * scalar);
  }

  // Element-wise multiplication
  IntVec multiply(IntVec other) {
    return IntVec(x * other.x, y * other.y);
  }

  // Euclidean distance between two vectors
  double distanceTo(IntVec other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  // Length of the vector
  double get length => sqrt(x * x + y * y);

  // Normalizes the vector to length 1 (unit vector)
  IntVec normalize() {
    final len = length;
    if (len == 0) {
      return IntVec(0, 0);
    }
    return IntVec((x / len).round(), (y / len).round());
  }

  // Clone the vector
  IntVec clone() => IntVec(x, y);

  @override
  String toString() => 'IntVec($x, $y)';
}
