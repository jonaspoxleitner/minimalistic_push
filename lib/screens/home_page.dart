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
  Color grey = Color(0xFFADB6C4);
  Color yellow = Color(0xFFFFEFD3);
  Color green = Color(0xFF3F5E5A);
  Color darkGreen = Color(0xFF263D42);

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (widget.start) {
      return Scaffold(
        backgroundColor: green,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: size.height / 2,
              ),
              height: size.height / 2,
              width: size.width,
              color: darkGreen,
            ),
            Container(
              height: size.height / 2,
            ),
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome  to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Minimalistic Push',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        widget.start = false;
                      });
                    },
                    child: Text('start'),
                  ),
                ],
              ),
            ),
          ],
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
            child: Column(
              children: [
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
              ],
            ),
          ),
        ),
      );
    }
  }
}
