
class Logitem {
  int id;
  String logType;
  String logBody;
  DateTime date;

  Logitem(
      {required this.id,
      required this.logType,
      required this.logBody,
      required this.date});

  factory Logitem.fromJson(Map<String, dynamic> json) {
    return Logitem(
      id: json['id'] as int,
      logType: json['logType'] as String,
      logBody: json['logBody'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
