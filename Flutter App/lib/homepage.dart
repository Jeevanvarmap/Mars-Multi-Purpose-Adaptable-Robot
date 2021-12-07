import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ConnectionType = 'Bluetooth';
  String ModeType = 'Manual';
  bool Connection = false;
  String? ipadd = "";

  TextEditingController setupIP = TextEditingController();

  saveIP(ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('IP', "$ip");
  }

  Future<int> CheckConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('IP');
    final response = await http.get(Uri.parse("http://$ip:5000"));
    if (response.statusCode == 200) {
      setState(() {
        Connection = true;
        ipadd = ip;
      });
      print("http://$ipadd:5000/video_feed");
      print(response.statusCode);
      return 1;
    } else {
      setState(() {
        Connection = false;
      });
      print(response.statusCode);
      return 0;
    }
  }

  Future<void> move(String direction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('IP');
    final response =
        await http.get(Uri.parse("http://$ip:5000/move/$direction"));
    if (response.statusCode == 200) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Error Connecting to the Bot',
        textAlign: TextAlign.center,
      )));
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.black87,
                size: 21,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  'Made with ♥ by Vitians',
                  textAlign: TextAlign.center,
                )));
              },
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Image.asset(
            'assets/logo.png',
            scale: 3.5,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Select Your connection type",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.5)),
                              elevation: 16,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    Center(
                                        child: Text(
                                      "Setup",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    SizedBox(height: 20),
                                    TextField(
                                        controller: setupIP,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Raspberry Pi\'s IP',
                                        )),
                                    SizedBox(height: 5),
                                    RaisedButton(
                                        child: new Text(
                                          'Check Connection',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blue,
                                        onPressed: () async {
                                          String url = setupIP.text;
                                          final response = await http.get(
                                              Uri.parse("http://$url:5000"));
                                          if (response.body ==
                                              "Multipurpose Adaptable Robot (Mars)") {
                                            print(response.body);
                                            saveIP(url);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor:
                                                        Colors.lightGreen,
                                                    content: Text(
                                                      'Mars Connected',
                                                      textAlign:
                                                          TextAlign.center,
                                                    )));
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                              'TRY AGAIN',
                                              textAlign: TextAlign.center,
                                            )));
                                            print(response.statusCode);
                                          }
                                        }),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
//                RaisedButton(
//                    child: Text("test"),
//                    onPressed: () async {
//                      SharedPreferences prefs =
//                          await SharedPreferences.getInstance();
//                      String? ip = prefs.getString('IP');
//                      print(ip);
//                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: ConnectionType,
                            iconSize: 21,
                            icon: (null),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                ConnectionType = newValue!;
                                CheckConnection();
                              });
                            },
                            items: <String>['Bluetooth', 'Internet']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[100],
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.black87,
                              size: 18,
                            ),
                            onPressed: () {
                              CheckConnection();
                            })),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    color: Colors.grey[500],
                    padding: EdgeInsets.all(3),
                    height: 200,
                    width: double.infinity,
                    child: Connection
                        ? WebView(
                            initialUrl: 'http://$ipadd:5000/video_feed',
//                            javascriptMode: JavascriptMode.unrestricted,
                          )
                        : Center(
                            child: Text(
                            'Complete Setup',
                            style: TextStyle(color: Colors.white),
                          ))),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mode:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(Radius.circular(3.0))),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: ModeType,
                            iconSize: 21,
                            icon: (null),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                ModeType = newValue!;
                                CheckConnection();
                              });
                            },
                            items: <String>[
                              'Manual',
                              'Object Tracking',
                              'Obstacle Avoiding'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    String direction = 'f';
                    move(direction);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        String direction = 'l';
                        move(direction);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.arrow_left,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        String direction = 's';
                        move(direction);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[700],
                        child: Icon(
                          Icons.stop,
                          size: 30,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        String direction = 'r';
                        move(direction);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    String direction = 'b';
                    move(direction);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
