import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:rust_genetics/widgets.dart';
import 'package:rust_genetics/dialogs.dart';
import 'package:rust_genetics/pages.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rust Genetics',
      home: LoaderOverlay(
        useDefaultLoading: true,
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _clones = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rust Genetics')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Stack(children: <Widget>[
                Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Super SECRET Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                    )
                  )
                ),
              ]),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:
                    Alignment(0.8, 0.0),
                  colors: <Color>[
                    Color(0xff55CDFC),
                    Color(0xffF7A8B8)
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
            // ListTile(
            //   title: Text('How to crossbreed'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(context, new MaterialPageRoute(
            //       builder: (BuildContext context) {
            //         return HowToPage();
            //       },
            //     ));
            //   },
            // ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset('assets/icon/rust_logo.png'),
                  applicationName: 'Rust Genetics Solver',
                  applicationVersion: '1.0.01',
                  children: [
                    Text("Heya! I hope you find this app usefull."),
                    Text("Let me know of any bugs here:"),
                    InkWell(
                      child: Text('Reddit',style: TextStyle(color: Colors.blue)),
                      onTap: () => launch('https://www.reddit.com/user/Lillien_Lily')
                    ),
                    InkWell(
                      child: Text('Discord',style: TextStyle(color: Colors.blue)),
                      onTap: () => launch('https://discordapp.com/users/359404497925177346/')
                    ),
                  ]
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(children: _getItems()),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 56,),
          ElevatedButton(
            child: Text('Calculate'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              )
            ),
            onPressed: _clones.length == 0 ? null : () {
              idealGeneDialog(context, _clones);
            }
          ),
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
    setState(() {
      _clones.remove(title);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clone $title deleted'),duration: const Duration(seconds: 1))
    );
  }


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
