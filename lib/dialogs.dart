import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:rust_genetics/logic_functions.dart';
import 'package:rust_genetics/widgets.dart';

final TextEditingController _textFieldController = TextEditingController(text: 'GGGYYY');

Future<AlertDialog> errorDialog(BuildContext contextt, int percentage, plants, ideal) async {
  return showDialog(
    context: contextt,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Chances of finding a solution'),
        content: Text('There is only a $percentage% chance to solve. Anything below 50% should not be run as it can take more than an hour just to tell you there are no solutions'),
        actions: [
          FlatButton(
            onPressed: () {Navigator.of(contextt).pop();},
            child: Text('CANCEL'),
          ),
          FlatButton(
            textColor: Colors.red,
            onPressed: () async {
              Navigator.of(contextt).pop();
              contextt.showLoaderOverlay();
              await run(contextt, plants, ideal, true);
              contextt.hideLoaderOverlay();
            },
            child: Text('CONTINUE'),
          ),
        ],
      );
    }
  );
}

Future<AlertDialog> idealGeneDialog(BuildContext contextt, List<String> clones) async {
  return showDialog(
    context: contextt,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choose your pefered genetics'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Only G and Y allowed for now'),
              TextField(
                autofocus: true,
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: 'Enter genetics here'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[gyGY]')),
                  LengthLimitingTextInputFormatter(6),
                  UpperCaseTextFormatter()
                ],
                onSubmitted: (value) async {
                  if (_textFieldController.text.length == 6) {
                    Navigator.of(context).pop();
                    contextt.showLoaderOverlay();
                    await run(contextt, clones, _textFieldController.text);
                    contextt.hideLoaderOverlay();
                  } else {
                    ScaffoldMessenger.of(contextt).showSnackBar(
                      SnackBar(content: Text('Not enough characters - (6)'))
                    );
                  }
                }
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('CONTINUE'),
            onPressed: () async {
              if (_textFieldController.text.length == 6) {
                Navigator.of(context).pop();
                contextt.showLoaderOverlay();
                await run(contextt, clones, _textFieldController.text);
                contextt.hideLoaderOverlay();
              } else {
                ScaffoldMessenger.of(contextt).showSnackBar(
                  SnackBar(content: Text('Not enough characters - (6)'))
                );
              }
            },
          )
        ],
      );
    }
  );
}

Future<AlertDialog> noSolutionDialog(BuildContext contextt) async {
  return showDialog(
    context: contextt,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No solutions found'),
        content: Text('After 3 breeding cycles, no results were found. Try adding more/better clones until it solves'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(contextt).pop();
            },
            child: Text('CONTINUE'),
          ),
        ],
      );
    }
  );
}
Future<AlertDialog> aboutDialog(BuildContext contextt) async {
  return showDialog(
    context: contextt,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No solutions found'),
        content: Text(''),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(contextt).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    }
  );
}
