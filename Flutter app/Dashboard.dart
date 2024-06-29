import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_workspace/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../../main.dart';

class NurseCallSystem extends StatefulWidget {
  @override
  _NurseCallSystemState createState() => _NurseCallSystemState();
}

class _NurseCallSystemState extends State<NurseCallSystem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List <double> heights = [0,0,0,0,0];
  List <int> beds = [0,0,0,0,0];
  List <int> rooms = [0,0,0,0,0];
  List <double> thickness = [0,0,0,0,0];
  List <String> Messages = ['','','','',''];
  List <String> Times = ['','','','',''];
  String Message = "";
  Color color1 = Colors.black;
  Color color2 = Colors.black;
  Color color3 = Colors.black;
  Color color4 = Colors.black;
  var flag =0;
  MqttServerClient? client;


  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        connectToMQTTBroker();
      }
    });
    connectToMQTTBroker();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> connectToMQTTBroker() async {

    if (client != null && client!.connectionStatus?.state == MqttConnectionState.connected) {
      setState(() {
        Message = "There are no calls";
      });
      return;
    }

    client = MqttServerClient.withPort('192.168.1.110', 'flutterClient', 1883);
    client!.logging(on: true);
    client!.keepAlivePeriod = 20;

    try {
      await client!.connect();
    } catch (e) {
      client!.disconnect();
    }

    if (client!.connectionStatus?.state == MqttConnectionState.connected) {
      client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

        print('Received message: $payload from topic: ${c[0].topic}');

        if (c[0].topic == 'esp32/bed1/room1') {
          setState(() {
            if (payload != "BLACK") {
              flag=1;
              Times[1] = DateFormat('hh:mm a').format(DateTime.now());
              Message = "";
              heights[1]=130;
              thickness[1] = 1;
              beds[1] = 1;
              rooms[1] = 1;
              if(payload=="RED")
              {
                Messages[1] = "Emergency call";
                color1 = Colors.red;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 1,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Emergency call from Room 1, Bed 1',
                  ),
                );
              }
              else if(payload=="YELLOW")
              {
                Messages[1] = "Normal call";
                color1 = Colors.yellow;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 2,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Normal call from Room 1, Bed 1',
                  ),
                );
              }

            }
            else{
              flag=0;
              heights[1]=0;
              thickness[1]=0;

            }
          });
        }
        if (c[0].topic == 'esp32/bed2/room1') {
          setState(() {
            if (payload != "BLACK") {
              flag=1;
              Times[2] = DateFormat('hh:mm a').format(DateTime.now());
              Message = "";
              heights[2]=130;
              thickness[2] = 1;
              beds[2] = 2;
              rooms[2] = 1;
              if(payload=="RED")
              {
                Messages[2] = "Emergency call";
                color2 = Colors.red;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 3,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Emergency call from Room 1, Bed 2',
                  ),
                );
              }
              else if(payload=="YELLOW")
              {
                Messages[2] = "Normal call";
                color2 = Colors.yellow;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 4,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Normal call from Room 1, Bed 2',
                  ),
                );
              }
            }
            else{
              flag=0;
              heights[2]=0;
              thickness[2]=0;

            }
          });
        }
        if (c[0].topic == 'esp32/bed1/room2') {
          setState(() {
            if (payload != "BLACK") {
              flag=1;
              Times[3] = DateFormat('hh:mm a').format(DateTime.now());
              beds[3] = 1;
              rooms[3] = 2;
              Message = "";
              heights[3]=130;
              thickness[3] = 1;
              if(payload=="RED")
              {
                Messages[3] = "Emergency call";
                color3 = Colors.red;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Emergency call from Room 2, Bed 1',
                  ),
                );
              }
              else if(payload=="YELLOW")
              {
                Messages[3] = "Normal call";
                color3 = Colors.yellow;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 6,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Normal call from Room 2, Bed 1',
                  ),
                );
              }
            }
            else{
              flag=0;
              heights[3]=0;
              thickness[3]=0;

            }
          });
        }
        if (c[0].topic == 'esp32/bed2/room2') {
          setState(() {
            if (payload != "BLACK") {
              flag=1;
              Times[4] = DateFormat('hh:mm a').format(DateTime.now());
              beds[4] = 2;
              rooms[4] = 2;
              Message = "";
              heights[4]=130;
              thickness[4] = 1;
              if(payload=="RED")
              {
                Messages[4] = "Emergency call";
                color4 = Colors.red;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 7,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Emergency call from Room 2, Bed 2',
                  ),
                );
              }
              else if(payload=="YELLOW")
              {
                Messages[4] = "Normal call";
                color4 = Colors.yellow;
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 8,
                    channelKey: 'basic_channel',
                    title: 'Button Pressed',
                    body: 'Normal call from Room 2, Bed 2',
                  ),
                );
              }
            }
            else{
              flag=0;
              heights[4]=0;
              thickness[4]=0;

            }
          });
        }


      });

      await subscribeToTopic(client!, 'esp32/bed1/room1');
      await subscribeToTopic(client!, 'esp32/bed2/room1');
      await subscribeToTopic(client!, 'esp32/bed1/room2');
      await subscribeToTopic(client!, 'esp32/bed2/room2');

      if(flag==0)
      {
        setState(() {
          Message = "There are no calls";
        });

      }
    } else {
      setState(() {
        Message = "Mobile is not connected";
      });
    }


  }

  Future<void> subscribeToTopic(MqttServerClient client, String topic) async {
    client.subscribe(topic, MqttQos.atLeastOnce);
    print('Subscribed to topic: $topic');
  }


  void publishMessage(String topic, String message) {
    if (client != null && client!.connectionStatus?.state == MqttConnectionState.connected) {
      try {
        final builder = MqttClientPayloadBuilder();
        builder.addString(message);
        client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
        print('Message published to $topic: $message');
      } catch (e) {
        print('Error publishing message: $e');
      }
    } else {

    }
  }

  void resetBed(String topic) {
    publishMessage(topic, "RESET");
    setState(() {
      if (topic == 'esp32/bed1/room1/reset') {
        heights[1] = 0;
        thickness[1] = 0;

      }
      if (topic == 'esp32/bed2/room1/reset') {
        heights[2] = 0;
        thickness[2] = 0;
      }
      if (topic == 'esp32/bed1/room2/reset') {
        heights[3] = 0;
        thickness[3] = 0;
      }
      if (topic == 'esp32/bed2/room2/reset') {
        heights[4] = 0;
        thickness[4] = 0;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: themeNotifier.isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Nurse Call System',
          style:TextStyle(
            color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
          ) ,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading:
              Icon(
                Icons.lightbulb_outline,
                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text('Toggle Dark Mode'),
              onTap: () {
                themeNotifier.toggleTheme();
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body:Container(
        color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.grey, // Customize the color if needed
                height: 1,          // Space the divider takes up
                thickness: 1,       // Thickness of the divider line
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: double.infinity,
                  color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
                  height: heights[1],
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Bed ${beds[1]}, Room ${rooms[1]}',
                                style: TextStyle(
                                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 25,),
                            Expanded(
                              child: Text(
                                '[${Messages[1]}]',
                                style: TextStyle(
                                  color: color1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Text(
                          'Time: ${Times[1]}',
                          style: TextStyle(
                            color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Center(
                          child: defaultbutton(
                            function: () {
                              resetBed("esp32/bed1/room1/reset");
                            },
                            color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                            textcolor: themeNotifier.isDarkMode ? Colors.black: Colors.white,
                            text: "RESPOND",
                            height: 60,
                            width: 200,
                            radius: 0,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  color:themeNotifier.isDarkMode ? Colors.white: Colors.black,
                  height: thickness[1],
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
                height: heights[2],
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bed ${beds[2]}, Room ${rooms[2]}',
                              style: TextStyle(
                                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 25,),
                          Expanded(
                            child: Text(
                              '[${Messages[2]}]',
                              style: TextStyle(
                                color: color2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        'Time: ${Times[2]}',
                        style: TextStyle(
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Center(
                        child: defaultbutton(
                          function: () {
                            resetBed("esp32/bed2/room1/reset");
                          },
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          textcolor: themeNotifier.isDarkMode ? Colors.black: Colors.white,
                          text: "RESPOND",
                          height: 60,
                          width: 200,
                          radius: 0,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  color:themeNotifier.isDarkMode ? Colors.white: Colors.black,
                  height: thickness[2],
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
                height: heights[3],
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bed ${beds[3]}, Room ${rooms[3]}',
                              style: TextStyle(
                                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 25,),
                          Expanded(
                            child: Text(
                              '[${Messages[3]}]',
                              style: TextStyle(
                                color: color3,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        'Time: ${Times[3]}',
                        style: TextStyle(
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Center(
                        child: defaultbutton(
                          function: () {
                            resetBed("esp32/bed1/room2/reset");
                          },
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          textcolor: themeNotifier.isDarkMode ? Colors.black: Colors.white,
                          text: "RESPOND",
                          height: 60,
                          width: 200,
                          radius: 0,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  color:themeNotifier.isDarkMode ? Colors.white: Colors.black,
                  height: thickness[3],
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
                height: heights[4],
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bed ${beds[4]}, Room ${rooms[4]}',
                              style: TextStyle(
                                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 25,),
                          Expanded(
                            child: Text(
                              '[${Messages[4]}]',
                              style: TextStyle(
                                color: color4,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        'Time: ${Times[4]}',
                        style: TextStyle(
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Center(
                        child: defaultbutton(
                          function: () {
                            resetBed("esp32/bed2/room2/reset");
                          },
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          textcolor: themeNotifier.isDarkMode ? Colors.black: Colors.white,
                          text: "RESPOND",
                          height: 60,
                          width: 200,
                          radius: 0,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  color:themeNotifier.isDarkMode ? Colors.white: Colors.black,
                  height: thickness[4],
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Center(
                  child: Text(
                       Message,
                    style: TextStyle(
                       fontSize: 30,
                        fontWeight: FontWeight.bold,
                      color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
