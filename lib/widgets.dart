import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}