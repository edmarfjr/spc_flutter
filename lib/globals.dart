  import 'dart:math';

const double gScale = 0.60;

double lerpAngle(double start, double end, double t) {
    final shortestAngle = (end - start + pi).remainder(2 * pi) - pi;
    return start + shortestAngle * t.clamp(0.0, 1.0);
  }