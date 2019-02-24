class Status {
  String id;
  String description;

  Status({this.id, this.description});

  factory Status.fromJson(Map<String, dynamic> json) {
    return new Status(id: json['Id'], description: json['Description']);
  }
}
