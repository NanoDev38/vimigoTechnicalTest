// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_application/Global/global.dart';
import 'package:flutter_application/Model/dataUser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vimigo Technical Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var hmsFormat = DateFormat('dd/MMM/yyyy hh:mm a');
  final now = DateTime.now();
  bool isChange = false, isLoading = true;

  List<int> hours = [];

  saveSession() async {
    final prefs = await SharedPreferences.getInstance();

    if(isChange){
      await prefs.setBool('hour', true);
    }
    else{
      await prefs.setBool('hour', false);
    }
  }

  convertToHour(){
    var inHor = 0;
    hours.clear();
    for(int i = 0; i < data.length; i++){
      var durationSinceNow = now.difference(data[i].checkIn);

      setState(() {
        hours.add(durationSinceNow.inHours);
        // var inHor = durationSinceNow.inHours;
      });
      
    }
    logger.i(hours.length);
  } 

  checkSession() async {
    final prefs = await SharedPreferences.getInstance();

    addData();

    if(prefs.getBool("hour") == true){
      setState(() {
        isLoading = false;
        isChange = true;
        convertToHour();
      });
    }else{
      setState(() {
        isLoading = false;
        isChange = false;
      });
        
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isChange = false;
    });
    checkSession();
    
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading ? 
      SizedBox(
          width: width,
          height: height,
          child: const SpinKitDualRing(
          color: Colors.blue,
          size: 50.0,
        ),
      ) : ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(
        color: Colors.white,
      ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: Center(child: Text(isChange ? "${hours[index].toString()} Hours ago" : hmsFormat.format(data[index].checkIn))),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(!isLoading){
            setState(() {
            if(isChange == true){
              isChange = false;
              saveSession();
            }else{
              convertToHour();
              isChange = true;
              saveSession();
            }
          });
          }else{
            logger.i("LOADING!!");
          }
          // logger.d(data[9].checkIn);
          // convertToHour(data[9].checkIn);
        },
        tooltip: 'Change',
        child: const Icon(Icons.add),
      ),
    );
  }
}
