import 'package:food_truck/Domain/Subitem.dart';

class Fnblist {
  String cinemaid;
  String tabName;
  String vistaFoodItemId;
  String name;
  String priceInCents;
  String itemPrice;
  String sevenStarExperience;
  String otherExperience;
  int subItemCount;
  String imageUrl;
  String imgUrl;
  String vegClass;
  List<Subitem> subitems;

  Fnblist(
      {this.cinemaid,
      this.tabName,
      this.vistaFoodItemId,
      this.name,
      this.priceInCents,
      this.itemPrice,
      this.sevenStarExperience,
      this.otherExperience,
      this.subItemCount,
      this.imageUrl,
      this.imgUrl,
      this.vegClass,
      this.subitems});

  factory Fnblist.fromJson(Map<String, dynamic> json) {
    return new Fnblist(
        cinemaid: json['Cinemaid'],
        tabName: json['TabName'],
        vistaFoodItemId: json['VistaFoodItemId'],
        name: json['Name'],
        priceInCents: json['PriceInCents'],
        itemPrice: json['ItemPrice'],
        sevenStarExperience: json['SevenStarExperience'],
        otherExperience: json['OtherExperience'],
        subItemCount: json['SubItemCount'],
        imageUrl: json['ImageUrl'],
        imgUrl: json['ImgUrl'],
        vegClass: json['VegClass'],
        subitems: (json['subitems'] as List)
            .map((value) => new Subitem.fromJson(value))
            .toList());
  }
}
