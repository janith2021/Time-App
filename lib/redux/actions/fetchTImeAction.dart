class FetchTimeAction{
  final String _location;
  final String _time;
  final String _date;

  String get location => _location;
  String get time => _time;
  String get date => _date;

  FetchTimeAction(this._location,this._time,this._date);
}