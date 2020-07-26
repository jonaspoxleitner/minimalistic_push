import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  var start = true;
  Widget title;

  HomePage(String titleText) {
    title = Text(titleText);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                widget.title,
                Expanded(
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          widget.start = false;
                          setState(() {});
                        },
                        child: Text('Go!')),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(children: [
              widget.title,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Text('$_counter'),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }
  }
}
