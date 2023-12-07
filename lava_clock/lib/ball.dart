import 'dart:math';
import 'dart:ui';

class ForcePoint {
  num x, y;

  num get magnitude => x * x + y * y;

  ForcePoint(this.x, this.y);

  double computed = 0;
  double force = 0;

  ForcePoint add(ForcePoint point) =>
      ForcePoint(point.x + this.x, point.y + this.y);

  ForcePoint copyWith({num? x, num? y}) => ForcePoint(x ?? this.x, y ?? this.y);
}

double vel({double ratio = 1}) =>
    (Random().nextDouble() > .5 ? 1 : -1) *
        (.2 + .25 * Random().nextDouble());

double calculatePosition(double fullSize) =>
    Random().nextDouble() * fullSize;

class Ball {
  final ForcePoint velocity;
  final double size;
  ForcePoint pos;

  static const i = .1;
  static const h = 1.5;

  Ball(Size size) :
    velocity = ForcePoint(vel(ratio: 0.25), vel()),
    pos = ForcePoint(
        calculatePosition(size.width), calculatePosition(size.height)),
    size = size.shortestSide / 15 +
        (Random().nextDouble() * (h - i) + i) * (size.shortestSide / 15);

  moveIn(Size size) {
    if (this.pos.x >= size.width - this.size) {
      if (this.pos.x > 0) this.velocity.x = -this.velocity.x;
      this.pos = pos.copyWith(x: size.width - this.size);
    } else if (this.pos.x <= this.size) {
      if (this.velocity.x < 0) this.velocity.x = -this.velocity.x;
      this.pos.x = this.size;
    }
    if (this.pos.y >= size.height - this.size) {
      if (this.velocity.y > 0) this.velocity.y = -this.velocity.y;
      this.pos.y = size.height - this.size;
    } else if (this.pos.y <= this.size) {
      if (this.velocity.y < 0) this.velocity.y = -this.velocity.y;
      this.pos.y = this.size;
    }
    this.pos = this.pos.add(this.velocity);
  }
}
