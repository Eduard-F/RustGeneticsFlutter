import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arrow_path/arrow_path.dart';


Widget buildSeedItem(String title) {
  final String seed = title;
  return Padding(
    padding: const EdgeInsets.only(top: 2.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 2),
        GeneCircle(seed[0]),
        SizedBox(width: 2),
        GeneCircle(seed[1]),
        SizedBox(width: 2),
        GeneCircle(seed[2]),
        SizedBox(width: 2),
        GeneCircle(seed[3]),
        SizedBox(width: 2),
        GeneCircle(seed[4]),
        SizedBox(width: 2),
        GeneCircle(seed[5]),
        SizedBox(width: 2),
      ],
    )
  );
}

class Seed extends StatelessWidget {
  final String seed;
  Seed(this.seed);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 2),
        GeneCircle(seed[0]),
        SizedBox(width: 2),
        GeneCircle(seed[1]),
        SizedBox(width: 2),
        GeneCircle(seed[2]),
        SizedBox(width: 2),
        GeneCircle(seed[3]),
        SizedBox(width: 2),
        GeneCircle(seed[4]),
        SizedBox(width: 2),
        GeneCircle(seed[5]),
        SizedBox(width: 2),
      ],
    );
  }
}

class GeneCircle extends StatelessWidget {
  final String text;
  GeneCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: ['X', 'W', 'x', 'w'].contains(text) ? Colors.red : Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(2, 2)
          )
        ]
        // border: Border.all(
        //   color: Color.fromRGBO(0, 0, 0, 0.7),
        //   width: 1,
        // ),
      ),
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 25,
          color: Colors.white
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Genetic {
  String label;
  bool fifty_fifty;
  int id;
  List<int> parents;
  Genetic(String label,bool fifty_fifty,int id, List<int> parents) {
    this.label = label;
    this.fifty_fifty = fifty_fifty;
    this.id = id;
    this.parents = parents;
  }

  String get key {
    return this.label;
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    TextSpan textSpan;
    TextPainter textPainter;
    Path path;

    // The arrows usually looks better with rounded caps.
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;

    /// Adjusted
    path = Path();
    path.moveTo(size.width/2, size.height/2);
    path.relativeCubicTo(0, 0, size.width * 0.5 - 50, size.height * 0.2, size.width * 0.5 - 50, size.height * 0.5 - 100);
    path = ArrowPath.make(path: path, isAdjusted: false);
    canvas.drawPath(path, paint..color = Colors.blue);

    textSpan = TextSpan(
      text: 'Try Adding Clones',
      style: TextStyle(color: Colors.blue),
    );
    textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.35, size.height * 0.45));
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}