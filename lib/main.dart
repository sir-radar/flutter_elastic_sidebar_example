import 'package:flutter/material.dart';
import 'drawer_painter.dart';
import 'my_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  bool isMenuOpen = false;

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration){
    RenderBox renderbox = globalKey.currentContext.findRenderObject();
    final position = renderbox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderbox.size.height - 20;
    double step = (contLimit - start)/6;
    limits = [];
    for (double x = start; x <= contLimit; x+=step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x){
    print(x);
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarWidth = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height / 2;

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 65, 108, 1.0),
          Color.fromRGBO(255, 75, 73, 1.0)
        ])),
        width: mediaQuery.width,
        child: Stack(children: <Widget>[
          Center(
              child: MaterialButton(
                  color: Colors.white,
                  child: Text(
                    "Hello world",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {})),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            left: isMenuOpen ? 0 : -sidebarWidth + 20,
            top: 0,
            curve: Curves.elasticOut,
            child: SizedBox(
              width: sidebarWidth,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.localPosition.dx <= sidebarWidth) {
                    setState(() {
                      _offset = details.localPosition;
                    });
                  }

                  if(details.localPosition.dx > sidebarWidth - 20 && details.delta.distanceSquared > 2 ){
                    setState(() {
                      isMenuOpen = true;
                    });
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    _offset = Offset(0, 0);
                  });
                },
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      size: Size(sidebarWidth, mediaQuery.height),
                      painter: DrawerPainter(offset: _offset),
                    ),
                    Container(
                      height: mediaQuery.height,
                      width: sidebarWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            height: mediaQuery.height * .25,
                            child: Center(
                                child: Column(
                              children: <Widget>[
                                Image.asset("assets/pic.jpeg",
                                    width: sidebarWidth / 2),
                                Text("Dynasty Studio",
                                    style: TextStyle(color: Colors.black45))
                              ],
                            )),
                          ),
                          Divider(thickness: 1),
                          Container(
                            key: globalKey,
                            width: double.infinity,
                            height: menuContainerHeight,
                            child: Column(children: <Widget>[
                              MyButton(
                                  text: "Profile",
                                  iconData: Icons.person,
                                  textSize: getSize(0),
                                  height: menuContainerHeight / 5),
                              MyButton(
                                  text: "Payments",
                                  iconData: Icons.payment,
                                  textSize: getSize(1),
                                  height: menuContainerHeight / 5),
                              MyButton(
                                  text: "Notification",
                                  iconData: Icons.notifications,
                                  textSize: getSize(2),
                                  height: menuContainerHeight / 5),
                              MyButton(
                                  text: "Settings",
                                  iconData: Icons.settings,
                                  textSize: getSize(3),
                                  height: menuContainerHeight / 5),
                              MyButton(
                                  text: "My Files",
                                  iconData: Icons.attach_file,
                                  textSize: getSize(4),
                                  height: menuContainerHeight / 5),
                            ]),
                          )
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 400),
                      right: isMenuOpen ? 10 : sidebarWidth,
                      bottom: 40,
                      child: IconButton(
                        enableFeedback: true,
                        icon: Icon(Icons.keyboard_backspace, color: Colors.black45, size: 30), 
                        onPressed: (){
                          setState(() {
                            isMenuOpen = false;
                          });
                        }
                        ),

                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    ));
  }
}
