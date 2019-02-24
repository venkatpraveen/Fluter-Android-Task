import 'package:food_truck/Domain/Fnblist.dart';

class FoodList {
  String tabName;
  List<Fnblist> fnblist;

  FoodList({this.tabName, this.fnblist});

  factory FoodList.fromJson(Map<String, dynamic> json) {
    return new FoodList(
        tabName: json['TabName'],
        fnblist: (json['fnblist'] as List)
            .map((value) => new Fnblist.fromJson(value))
            .toList());
  }
}
