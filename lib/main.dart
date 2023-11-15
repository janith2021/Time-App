import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeapp/redux/actions/fetchTImeAction.dart';
import 'package:timeapp/redux/appReducer.dart';
import 'package:timeapp/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(TimeApp());
}

class TimeApp extends StatelessWidget {
  List<String> country = ["Africa/Abidjan","Africa/Algiers",	"Asia/Yekaterinburg",	"Europe/Istanbul"];
  final store = Store(reducer,initialState: AppState.initialState());
  TimeApp({super.key});

  getTime() async{
    try {

      var location = country[Random().nextInt(country.length)];
      // debugPrint(location);
      var response = await http.get(Uri.parse("http://worldtimeapi.org/api/$location"));
      if(response.statusCode == 200){
        Map data = await jsonDecode(response.body);
        var date = data['datetime'].toString().split("T")[0];
        var time = data['datetime'].toString().split("T")[1].split('.')[0];

        store.dispatch(FetchTimeAction(data['timezone'], date,time));
      }
      // debugPrint(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }  
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(backgroundColor: Colors.white,appBar: AppBar(backgroundColor: Colors.blueAccent,title: Text("Time App",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,),),centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StoreConnector<AppState,AppState>(
                converter: (store) => store.state,
                builder: (_,state) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(boxShadow: const [BoxShadow(color: Colors.redAccent,blurRadius: 5,),],borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              state.location == "" ? Text("Click The Time Button",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20),) : Text(state.location,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20),),
                              state.date == "" ? const Text(""): Text(state.date,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18),),
                              state.time == "" ? const Text(""): Text(state.time,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18),)
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  );
                }
              ),
              ElevatedButton(onPressed: (){
                  getTime();
              },style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.indigo)), child: const Text("Check Time"),)
            ],
          ),
        ),
      ),
      ),
    );
  }
}