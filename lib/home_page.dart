import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/time_block.dart';

import 'button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Duration currentTime;
  Duration pomodoroTime= const Duration(seconds: 1500);
  Duration breakTime= const Duration(seconds: 300);
  bool isContinuePom=true; // Set the start button to activate at start and after reset button is pressed
  bool toggleNamePom=true; // Toggling button name between pause and continue
  bool isContinueBreak=true;
  bool pomodo=false;
  bool breako=false;
  bool toggleNameBrake=true;
  String buttonName="Pause";
  int currentPageIndex=0;
  Timer? pomTimer;
  Timer? breakTimer;
  late List<Widget> timers;
@override
  void initState() {
    // TODO: implement initState
  currentTime=pomodoroTime;
  timers=[
    TimeBlock(duration: pomodoroTime),
    TimeBlock(duration: breakTime),
  ];
    super.initState();
  }
  void timeStart(){
    if(currentPageIndex==0 && pomodo){
      setState(() {
        pomodoroTime=Duration(seconds: pomodoroTime.inSeconds-1);
        currentTime=pomodoroTime;
        breakTimer?.cancel();
      });
    }
    if(currentPageIndex==1 && breako){
      setState(() {
        breakTime=Duration(seconds: breakTime.inSeconds-1);
        currentTime=breakTime;
      });
    }
    timers=[
      TimeBlock(duration: pomodoroTime),
      TimeBlock(duration: breakTime),
    ];
  }
  void start(){
    if(currentPageIndex==0){
      isContinuePom=false;
      pomodo=true;
      breako=false;
      breakTimer?.cancel();
      pomTimer =Timer.periodic(const Duration(seconds: 1), (_) {
        timeStart();
      });
    }
    else{
      isContinueBreak=false;
      breako=true;
      pomodo=false;
      pomTimer?.cancel();
      breakTimer=Timer.periodic(const Duration(seconds: 1), (_) {
        timeStart();
      });
    }
  }
  void stop(){
    if(currentPageIndex==0){
      pomTimer?.cancel();
      setState(() {
        if(!toggleNamePom){
          buttonName="Pause";
          start();
        }
        else{
          buttonName="Continue";
        }
        toggleNamePom=!toggleNamePom;
      });
    }
    else{
      breakTimer?.cancel();
      setState(() {
        if(!toggleNameBrake){
          buttonName="Pause";
          start();
        }
        else{
          buttonName="Continue";
        }
        toggleNameBrake=!toggleNameBrake;
      });
    }
  }

  void reset(){
  if(currentPageIndex==0){
    isContinuePom=true;
    setState(() {
      pomodoroTime= const Duration(seconds: 1500);
      pomTimer?.cancel();
    });
    timers=[
      TimeBlock(duration: pomodoroTime),
      TimeBlock(duration: breakTime),
    ];
  }else{
    isContinueBreak=true;
    setState(() {
      breakTime= const Duration(seconds: 300);
      breakTimer?.cancel();
    });
    timers=[
      TimeBlock(duration: pomodoroTime),
      TimeBlock(duration: breakTime),
    ];
  }

  }
  buttons(){
  if(currentPageIndex==0){
    bool timerIsActive= (pomTimer==null)?false:pomTimer!.isActive;
    if(!timerIsActive && isContinuePom){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(buttonName: "Start",onPressed: start),
        ],
      );
    }
    else{
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(buttonName: buttonName,onPressed: stop),
          const SizedBox(
            width: 15,
          ),
          Button(buttonName: "Reset",onPressed: reset),
        ],
      );
    }
  }
    else{
    bool timerIsActive= (breakTimer==null)?false:breakTimer!.isActive;
    if(!timerIsActive && isContinueBreak){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(buttonName: "Start",onPressed: start),
        ],
      );
    }
    else{
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(buttonName: buttonName,onPressed: stop),
          const SizedBox(
            width: 15,
          ),
          Button(buttonName: "Reset",onPressed: reset),
        ],
      );
    }
  }

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Pomodoro",
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Pomodoro",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white54,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width<500)?double.infinity:500,
              child: NavigationBar(
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.access_time_filled), label: "Pomodoro"),
                  NavigationDestination(icon: Icon(Icons.ac_unit), label: "Break"),
                ],
                selectedIndex: currentPageIndex,
                backgroundColor:  Colors.red.shade400,
                indicatorColor:  Colors.red.shade300,
                labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                onDestinationSelected: (index){
                  setState(() {
                    currentPageIndex=index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            timers[currentPageIndex],
            buttons(),
          ],
        ),
      ),
    );
  }
}
