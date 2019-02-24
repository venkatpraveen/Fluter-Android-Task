import 'package:food_truck/Domain/FoodList.dart';
import 'package:food_truck/Domain/Status.dart';

class MockJSON {
  Status status;
  String currency;
  List<FoodList> foodList;

  MockJSON({this.status, this.currency, this.foodList});

  factory MockJSON.fromJson(Map<String, dynamic> json) {
    return new MockJSON(
        status: new Status.fromJson(json['status']),
        currency: json['Currency'],
        foodList: (json['FoodList'] as List)
            .map((value) => new FoodList.fromJson(value))
            .toList());
  }
}
