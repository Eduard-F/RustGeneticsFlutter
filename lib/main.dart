// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:rust_genetics/widgets.dart';
import 'package:rust_genetics/dialogs.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rust',
      home: LoaderOverlay(
        useDefaultLoading: true,
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _clones = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rust Genetics')),
      body: Container(
        child: ListView(children: _getItems()),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // colors: [Colors.purple[900], Colors.purple]
            stops: [0.3, 0.5, 0.7],
            colors: [Color.fromRGBO(85, 205, 252, 1), Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(247, 168, 184, 1)]
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 56,),
          FloatingActionButton(
            heroTag: "calculate",
            onPressed: () {
              idealGeneDialog(context, _clones);
            },
            tooltip: 'Calculate',
            child: Icon(Icons.calculate)
          ),
          // SizedBox(
          //   width: 100,
          // ),
          FloatingActionButton(
            heroTag: "add_clone",
            onPressed: () => _displayDialog(context),
            tooltip: 'Add Clone',
            child: Icon(Icons.add)
          ),
        ],
      ),
    );
  }

  void _addClone(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    if (!_clones.contains(title)) {
      setState(() {
        _clones.add(title);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clone already exists'))
      );
    }
    _textFieldController.clear();
  }

  void _removeClone(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      _clones.remove(title);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clone $title deleted'),duration: const Duration(seconds: 1))
    );
  }

  // Generate a single item widget
  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a clone to your list'),
            content: TextField(
              autofocus: true,
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter genetics here'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[gyhxwGYHXW]')),
                LengthLimitingTextInputFormatter(6),
                UpperCaseTextFormatter()
              ],
              onSubmitted: (value) {
                if (_textFieldController.text.length == 6) {
                  Navigator.of(context).pop();
                  _addClone(_textFieldController.text);
                  if ('w'.allMatches(_textFieldController.text).length > 2 || 'x'.allMatches(_textFieldController.text).length > 2) {  
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Warning - try not to add clones that have 3+ red genes'),
                        duration: const Duration(seconds: 2)
                      )
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Not enough characters - (6)'))
                  );
                }
              }
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('ADD'),
                onPressed: () {
                  if (_textFieldController.text.length == 6) {
                    Navigator.of(context).pop();
                    _addClone(_textFieldController.text);
                    if ('w'.allMatches(_textFieldController.text).length > 2 || 'x'.allMatches(_textFieldController.text).length > 2) {  
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Warning - try not to add clones that have 3+ red genes'),
                          duration: const Duration(seconds: 2)
                        )
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not enough characters - (6)'))
                    );
                  }
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _cloneWidgets = <Widget>[];
    for (String title in _clones) {
      _cloneWidgets.add(_buildCloneItem(title));
    }
    return _cloneWidgets;
  }

  Widget _buildCloneItem(String title) {
    final String clone = title;
    return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 2),
            GeneCircle(clone[0]),
            SizedBox(width: 2),
            GeneCircle(clone[1]),
            SizedBox(width: 2),
            GeneCircle(clone[2]),
            SizedBox(width: 2),
            GeneCircle(clone[3]),
            SizedBox(width: 2),
            GeneCircle(clone[4]),
            SizedBox(width: 2),
            GeneCircle(clone[5]),
            SizedBox(width: 2),
            IconButton(icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ), onPressed: () => _removeClone(title))
          ],
        )
    );
  }

}
