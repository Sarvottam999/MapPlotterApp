// // A representation of a point on a 2D plane
// class Point<T extends num> {
//   final T x;
//   final T y;

//   const Point(this.x, this.y);

//   // Various utility methods and operators
//   Point<T> operator +(Point<T> other) => Point<T>(x + other.x, y + other.y);
//   Point<T> operator -(Point<T> other) => Point<T>(x - other.x, y - other.y);
  
//   Point<T> operator *(num factor) =>
//       Point<T>((x * factor) as T, (y * factor) as T);

//   bool operator ==(Object other) =>
//       other is Point<T> && other.x == x && other.y == y;

//   int get hashCode => Object.hash(x.hashCode, y.hashCode);

//   String toString() => 'Point($x, $y)';
// }