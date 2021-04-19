import 'package:flutter/material.dart';
import 'package:tappo/controller.dart';
import 'controller.dart';
import 'eps.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'tappo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Controller controller = new Controller();
  Future led;
  Future buzz;
  Future perc;
  Future active;
  Timer timer;
  DateTime curTime;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void getData() {
    setState(() {
      led = controller.fetchData(ledStatus);
      buzz = controller.fetchData(buzzStatus);
      perc = controller.fetchData(getPerc);
      active = controller.fetchData(getActive);
    });
  }

  void setTime() {
    setState(() {
      curTime = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => getData());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setTime());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
              children: <Widget>[
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Text(
                            "Latest Values",
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: FutureBuilder(
                                        future: perc,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);

                                          return snapshot.hasData
                                              ? (snapshot.data.length == 0
                                                  ? Text("No data")
                                                  : InkWell(
                                                      child: Card(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      1),
                                                              child: ListTile(
                                                                  title: Text(snapshot
                                                                      .data[0]
                                                                          ["data"]
                                                                          [
                                                                          "perc"]
                                                                      .toString()))))))
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        })),
                                Expanded(
                                    flex: 1,
                                    child: FutureBuilder(
                                        future: active,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);

                                          return snapshot.hasData
                                              ? (snapshot.data.length == 0
                                                  ? Text("No data")
                                                  : InkWell(
                                                      child: Card(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              child: ListTile(
                                                                  title: Text(snapshot.data[0]["on"]["setOn"]
                                                                              .toString() ==
                                                                          "1"
                                                                      ? "The lid is on"
                                                                      : "The lid is not on"))))))
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        }))
                              ])
                        ]))),
                //AGGR values
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Text(
                            "Aggregated Values",
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: FutureBuilder(
                                        future: perc,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);

                                          return snapshot.hasData
                                              ? (snapshot.data.length == 0
                                                  ? Text("No data")
                                                  : InkWell(
                                                      child: Card(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              child: ListTile(
                                                                  title: Text("In the last hour you filled: \n" +
                                                                      (controller.max(snapshot.data, "data", "perc") - controller.min(snapshot.data, "data", "perc"))
                                                                          .toString() +
                                                                      " %"))))))
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        })),
                                Expanded(
                                    flex: 1,
                                    child: FutureBuilder(
                                        future: active,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);

                                          return snapshot.hasData
                                              ? (snapshot.data.length == 0
                                                  ? Text("No data")
                                                  : InkWell(
                                                      child: Card(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              child: ListTile(
                                                                  title: Text((snapshot.data[0]["on"]["setOn"].toString() ==
                                                                              "1"
                                                                          ? "The lid is on from: \n"
                                                                          : "The lid is not on from \n") +
                                                                      _printDuration(
                                                                          curTime
                                                                              .difference(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data[0]["timestamp"]))))))))))
                                              : Center(child: CircularProgressIndicator());
                                        }))
                              ])
                        ]))),
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Text(
                            "Sensors values",
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(children: [
                                      Text(
                                        "%",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: FutureBuilder(
                                          future: perc,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError)
                                              print(snapshot.error);

                                            return snapshot.hasData
                                                ? (snapshot.data.length == 0
                                                    ? Text("No data")
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                              child: Card(
                                                                  child: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      child: ListTile(
                                                                          title: Text(snapshot
                                                                              .data[index]["data"]["perc"]
                                                                              .toString())))));
                                                        }))
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          },
                                        ),
                                      )
                                    ])),
                                Expanded(
                                    flex: 1,
                                    child: Column(children: [
                                      Text(
                                        "on",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: FutureBuilder(
                                            future: active,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError)
                                                print(snapshot.error);

                                              return snapshot.hasData
                                                  ? (snapshot.data.length == 0
                                                      ? Text("No data")
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: snapshot
                                                              .data.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            if (snapshot.data
                                                                    .length ==
                                                                0)
                                                              return Text(
                                                                  "No data");
                                                            else
                                                              return InkWell(
                                                                  child: Card(
                                                                      child: Padding(
                                                                          padding: EdgeInsets.all(
                                                                              1),
                                                                          child:
                                                                              ListTile(title: Text(snapshot.data[index]["on"]["setOn"].toString())))));
                                                          }))
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator());
                                            },
                                          ))
                                    ]))
                              ]),
                        ])))
              ],
            )), // This trailing comma makes auto-formatting nicer for build methods.
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: Padding(
                        padding: EdgeInsets.all(2.5),
                        child: RaisedButton(
                            color: Colors.teal,
                            child: FutureBuilder(
                                future: led,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);

                                  return snapshot.hasData
                                      ? (snapshot.data.length == 0
                                          ? Text("No data")
                                          : Text(
                                              "LED: " +
                                                  (snapshot.data[0]["setOn"]
                                                                  ["setOn"]
                                                              .toString() ==
                                                          "1"
                                                      ? "on"
                                                      : "off"),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ))
                                      : Center(
                                          child: Text(
                                          "LED: ...",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ));
                                }),
                            onPressed: () {
                              setState(() {
                                led = controller.fetchData(ledToggle);
                              });
                            }))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: Padding(
                        padding: EdgeInsets.all(2.5),
                        child: RaisedButton(
                            color: Colors.teal,
                            child: FutureBuilder(
                                future: buzz,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);

                                  return snapshot.hasData
                                      ? (snapshot.data.length == 0
                                          ? Text("No data")
                                          : Text(
                                              "BUZZER: " +
                                                  (snapshot.data[0]["setOn"]
                                                                  ["setOn"]
                                                              .toString() ==
                                                          "1"
                                                      ? "on"
                                                      : "off"),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ))
                                      : Center(
                                          child: Text(
                                          "BUZZER: ...",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ));
                                }),
                            onPressed: () {
                              setState(() {
                                buzz = controller.fetchData(buzzToggle);
                              });
                            }))),
              ],
            ),
          ),
        ]));
  }
}
