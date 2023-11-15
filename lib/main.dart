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
        store.dispatch(FetchTimeAction(data['timezone'], data['datetime']));
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
        home: Scaffold(backgroundColor: Colors.deepOrangeAccent,appBar: AppBar(backgroundColor: Colors.blueAccent,title: Text("Time App",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,),),centerTitle: true),
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
                        state.location == "" ? Text("Please Click Check Time Button",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20),) : Text(state.location,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20),),
                        state.time == "" ? const Text(""): Text(state.time,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18),),
                        
                      ],
                    ),
                  );
                }
              ),
              ElevatedButton(onPressed: (){
                  getTime();
              }, child: Text("Check Time"),style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.indigo)),)
            ],
          ),
        ),
      ),
      ),
    );
  }
}