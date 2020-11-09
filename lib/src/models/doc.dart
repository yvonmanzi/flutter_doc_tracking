import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Doc extends Equatable {
  final String title;
  final String expiration;

  final int notifyAtOneYearMark;
  final int notifyAtHalfYearMark;
  final int notifyAtQuarterMark;
  final int notifyAtMonthMark;

  Doc(
      {@required this.title,
      @required this.expiration,
      @required this.notifyAtOneYearMark,
      @required this.notifyAtHalfYearMark,
      @required this.notifyAtQuarterMark,
      @required this.notifyAtMonthMark})
      : assert(title != null && expiration != null);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['title'] = title;
    map['expiration'] = expiration;
    map['notifyAtOneYearMark'] = notifyAtOneYearMark;
    map['notifyAtHalfYearMark'] = notifyAtHalfYearMark;
    map['notifyAtQuarterMark'] = notifyAtQuarterMark;
    map['notifyAtMonthMark'] = notifyAtMonthMark;
    return map;
  }

  static Doc fromMap(dynamic json) {
    return Doc(
      title: json['title'],
      expiration: json['expiration'],
      notifyAtHalfYearMark: json['notifyAtHalfYearMark'],
      notifyAtMonthMark: json['notifyAtMonthMark'],
      notifyAtOneYearMark: json['notifyAtOneYearMark'],
      notifyAtQuarterMark: json['notifyAtQuarterMark'],
    );
  }

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'Doc: $title';
}
