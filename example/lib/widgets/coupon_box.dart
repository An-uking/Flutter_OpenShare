import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class CustomCouponShape extends ShapeBorder {
  final double rate;
  final double radius;
  final Axis direction;
  final Color dashedBorderColor;
  final double dashedBorderWidth;
  CustomCouponShape(
      {@required this.rate,
      this.radius = 10,
      this.direction = Axis.horizontal,
      this.dashedBorderColor = Colors.black,
      this.dashedBorderWidth = 1.0});
  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Rect oval, oval2;
    if (direction == Axis.horizontal) {
      oval = new Rect.fromCircle(
          center: Offset(rate * rect.size.width, 0), radius: radius);
      oval2 = new Rect.fromCircle(
          center: Offset(rate * rect.size.width, rect.size.height),
          radius: radius);
    } else {
      oval = new Rect.fromCircle(
          center: Offset(0, rate * rect.size.height), radius: radius);
      oval2 = new Rect.fromCircle(
          center: Offset(rect.size.width, rate * rect.size.height),
          radius: radius);
    }
    Path path = new Path()
      ..addRect(rect)
      ..close();
    Path path2 = new Path();
    path2.addArc(oval, 0, 180);
    path = Path.combine(PathOperation.reverseDifference, path2, path);
    path2.addArc(oval2, 0, 180);
    return Path.combine(PathOperation.reverseDifference, path2, path);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    Paint paint = Paint()
      ..color = dashedBorderColor
      ..strokeWidth = dashedBorderWidth
      ..style = PaintingStyle.stroke;
    Path p = Path();
    double dx, dy;
    if (direction == Axis.horizontal) {
      dx = rate * rect.size.width;
      dy = radius + 5;
      p
        ..moveTo(dx, dy)
        ..lineTo(dx, rect.size.height - dy);
    } else {
      dx = radius + 5;
      dy = rate * rect.size.height;
      p
        ..moveTo(dx, dy)
        ..lineTo(rect.size.width - dx, dy);
    }
    canvas.drawPath(
        dashPath(
          p,
          dashArray: CircularIntervalList<double>(
            <double>[5.0, 2.5],
          ),
        ),
        paint);
  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class CouponBox extends StatelessWidget {
  final double width;
  final double height;
  final double rate;
  final double radius;
  final Axis direction;
  final Color dashedBorderColor;
  final double dashedBorderWidth;
  final Widget firstChild;
  final Widget secondChild;
  final Color backgroundColor;
  CouponBox(
      {@required this.rate,
      @required this.width,
      @required this.height,
      this.radius = 10,
      this.backgroundColor = Colors.redAccent,
      this.direction = Axis.horizontal,
      this.dashedBorderColor = Colors.black,
      this.dashedBorderWidth = 1.0,
      this.firstChild,
      this.secondChild});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: backgroundColor,
        shape: CustomCouponShape(
            rate: rate,
            radius: radius,
            direction: direction,
            dashedBorderColor: dashedBorderColor,
            dashedBorderWidth: dashedBorderWidth),
        child: direction == Axis.vertical
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: height * rate,
                    child: firstChild,
                  ),
                  SizedBox(
                    height: radius,
                  ),
                  Expanded(
                    child: secondChild,
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    width: width * rate,
                    child: firstChild,
                  ),
                  SizedBox(
                    width: radius,
                  ),
                  Expanded(
                    child: secondChild,
                  )
                ],
              ),
      ),
    );
  }
}