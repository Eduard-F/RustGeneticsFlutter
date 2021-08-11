import 'package:flutter/material.dart';

import 'package:rust_genetics/widgets.dart';

class ResultPage extends StatefulWidget {
  final List<List<Map<String, Object>>> plants;

  const ResultPage(this.plants);
  
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rust Genetics')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end:
              Alignment(0.8, 0.0),
            colors: <Color>[
              Color(0xffF7A8B8),
              Color(0xff55CDFC),
            ],
            tileMode: TileMode.repeated
          ),
        ),
        child: new Center(
          child: new ListView(
            children: _getResultRows(widget.plants)
          ),
        ),
      ),
    );
  }

  List<Widget> _getResultRows(plants) {
    final List<Widget> _rowWidgets = <Widget>[];
    int idx = 0;
    for (List row in plants) {
      idx++;
      _rowWidgets.add(
        Center(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              'Plant cycle: ' + idx.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: Colors.white
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
              gradient: LinearGradient(
                colors: [Color(0xff7E55B4), Colors.purple]
              ),
            ),
          ),
        )
      );
      _rowWidgets.add(_buildRowItem(row));
    }
    return _rowWidgets;
  }

  Widget _buildRowItem(List row) {
    return Container(
      height: 330.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: _buildColumnItem(row)
      ),
    );
  }

  List<Widget> _buildColumnItem(List row) {
    final List<Widget> _columnWidgets = <Widget>[];
    
    for (Map column in row) {
      _columnWidgets.add(
        Container(
          child: Column(children: _getResultItems(column)),
        )
      );
      _columnWidgets.add(SizedBox(width: 40));
    }
    return _columnWidgets;
  }

  List<Widget> _getResultItems(plantz) {
    final List<Widget> _seedWidgets = <Widget>[];
    for (var i = 0; i < 4; i++) {
      _seedWidgets.add(buildSeedItem(plantz['plants'][i]));
    }
    _seedWidgets.add(_buildResultSeedItem(plantz['plants'][4], plantz['fifty_fifty']));
    if (plantz['fifty_fifty']) {
      _seedWidgets.add(Text(
        'Fifty fifty method',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),
      ));
    }
    return _seedWidgets;
  }

  Widget _buildResultSeedItem(String title, bool fifty) {
    final String seed = title;
    return Column(
      children: [
        Text(
          'Result',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
        ),
        Row(
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
      ],
    );
  }
}

class HowToPage extends StatefulWidget {
  @override
  _HowToPageState createState() => _HowToPageState();
}

class _HowToPageState extends State<HowToPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How To')),
      body: Container(
        child: ListView(
          children: [
            Text('hello'),
            Text('bye')
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end:
              Alignment(0.8, 0.0),
            colors: <Color>[
              Color(0xffF7A8B8),
              Color(0xff55CDFC),
            ],
            tileMode: TileMode.repeated
          ),
        ),
      ),
    );
  }
}

