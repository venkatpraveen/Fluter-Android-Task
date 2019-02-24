class Subitem {
  String name;
  String priceInCents;
  String subitemPrice;
  String vistaParentFoodItemId;
  String vistaSubFoodItemId;

  Subitem(
      {this.name,
      this.priceInCents,
      this.subitemPrice,
      this.vistaParentFoodItemId,
      this.vistaSubFoodItemId});

  factory Subitem.fromJson(Map<String, dynamic> json) {
    return new Subitem(
      name: json['Name'],
      priceInCents: json['PriceInCents'],
      subitemPrice: json['SubitemPrice'],
      vistaParentFoodItemId: json['VistaParentFoodItemId'],
      vistaSubFoodItemId: json['VistaSubFoodItemId'],
    );
  }
}
