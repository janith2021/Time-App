import 'package:timeapp/redux/actions/fetchTImeAction.dart';
import 'package:timeapp/redux/appState.dart';

AppState reducer(AppState previous,dynamic action){
  if(action is FetchTimeAction) {
    return AppState(action.location, action.time, action.date);
  } else {
    return previous;
  }
}