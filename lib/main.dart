import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stop Watch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Stop Watch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$minutesStr:$secondsStr',
              style: Theme.of(context).textTheme.headline4,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    myButton(buttonTitle: "START", buttonColor: Colors.green, onButtonClicked: (){
                      if(secondsStr == '00'){
                        timerStream = stopWatchStream();
                        timerSubscription = timerStream.listen((int newTick) {
                          setState(() {
                            minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');

                            secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
                          });
                        });
                      }
                    }),
                    myButton(buttonTitle: "RESET", buttonColor: Colors.amberAccent, onButtonClicked: (){
                      timerSubscription.cancel();
                      timerStream = null;
                      setState(() {
                        minutesStr = '00';
                        secondsStr = '00';
                      });
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
     );
  }
}
