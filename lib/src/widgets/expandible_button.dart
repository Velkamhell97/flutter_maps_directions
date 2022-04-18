import 'package:flutter/material.dart';

class ExpandibleButton extends StatelessWidget {
  final bool showSearchBar;
  final VoidCallback onTap;

  const ExpandibleButton({Key? key, required this.showSearchBar, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
           CustomPaint(
            painter: _NotchedPainter(),
          ),
          ClipPath(
            clipper: _NotchedClipper(),
            child: Material(
              child: InkWell(
                onTap: onTap,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: showSearchBar ? 0 : 0.5,
                  child: const Icon(Icons.expand_less)
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}

class _NotchedClipper extends CustomClipper<Path> {
  static const _fabSize = 64.0;

  @override
  Path getClip(Size size) {
    final Rect host = const Offset(0.0, 0.0) & size;
    final Rect guest = Rect.fromCircle(center: host.topCenter, radius: _fabSize);

    final Offset sp  = Offset(host.width * 0.20, 0.0);
    final Offset cp1 = Offset(host.width * 0.08, 0.0);
    final Offset cp2 = Offset(host.width * 0.08, host.height * 0.9);
    final Offset ep  = Offset(0.0, host.height * 0.9);

    final List<Offset?> p = List<Offset?>.filled(7, null, growable: false);

    p[0] = Offset(-sp.dx,  sp.dy);
    p[1] = Offset(-cp1.dx, cp1.dy);
    p[2] = Offset(-cp2.dx, cp2.dy);
    p[3] = Offset(-ep.dx,  ep.dy);

    p[4] = Offset(-1.0 * p[2]!.dx, p[2]!.dy);
    p[5] = Offset(-1.0 * p[1]!.dx, p[1]!.dy);
    p[6] = Offset(-1.0 * p[0]!.dx, p[0]!.dy);

    for (int i = 0; i < p.length; i += 1) {
      p[i] = p[i]! + guest.center;
    }

    final path = Path()
      ..moveTo(p[0]!.dx, p[0]!.dy)
      ..cubicTo(p[1]!.dx, p[1]!.dy, p[2]!.dx, p[2]!.dy, p[3]!.dx, p[3]!.dy)
      ..cubicTo(p[4]!.dx, p[4]!.dy, p[5]!.dx, p[5]!.dy, p[6]!.dx, p[6]!.dy)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _NotchedPainter extends CustomPainter {
  static const _fabSize = 64.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect host = const Offset(0.0, 0.0) & size;
    final Rect guest = Rect.fromCircle(center: host.topCenter, radius: _fabSize);

    final Offset sp  = Offset(host.width * 0.20, 0.0);
    final Offset cp1 = Offset(host.width * 0.08, 0.0);
    final Offset cp2 = Offset(host.width * 0.08, host.height * 0.9);
    final Offset ep  = Offset(0.0, host.height * 0.9);

    final List<Offset?> p = List<Offset?>.filled(7, null, growable: false);

    p[0] = Offset(-sp.dx,  sp.dy);
    p[1] = Offset(-cp1.dx, cp1.dy);
    p[2] = Offset(-cp2.dx, cp2.dy);
    p[3] = Offset(-ep.dx,  ep.dy);

    p[4] = Offset(-1.0 * p[2]!.dx, p[2]!.dy);
    p[5] = Offset(-1.0 * p[1]!.dx, p[1]!.dy);
    p[6] = Offset(-1.0 * p[0]!.dx, p[0]!.dy);

    for (int i = 0; i < p.length; i += 1) {
      p[i] = p[i]! + guest.center;
    }

    final path = Path()
      ..moveTo(p[0]!.dx, p[0]!.dy)
      ..cubicTo(p[1]!.dx, p[1]!.dy, p[2]!.dx, p[2]!.dy, p[3]!.dx, p[3]!.dy)
      ..cubicTo(p[4]!.dx, p[4]!.dy, p[5]!.dx, p[5]!.dy, p[6]!.dx, p[6]!.dy)
      ..close();

    final paint1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawShadow(path, Colors.black38, 5, false);
    canvas.clipPath(path);
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(_NotchedPainter oldDelegate) => false;
}