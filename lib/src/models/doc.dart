import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Doc extends Equatable {
  final int id;
  final String title;
  final String expiration;

  final int remainingMonths;

  Doc(
      {@required this.title,
      @required this.expiration,
      @required this.id,
      @required this.remainingMonths})
      : assert(title != null && expiration != null && remainingMonths != null);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['title'] = this.title;
    if (id != null) map['id'] = this.id;
    map['expiration'] = this.expiration;
    map['remainingMonths'] = this.remainingMonths;
    return map;
  }

  static Doc fromMap(dynamic json) {
    return Doc(
      id: json['id'],
      title: json['title'],
      expiration: json['expiration'],
      remainingMonths: json['remainingMonths'],
    );
  }

  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Doc: $title';
}
