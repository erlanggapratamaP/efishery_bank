class Area {
  String? province;
  String? city;

  Area({ this.province, this.city});

  Area.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['province'] = province;
    data['city'] = city;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'province': province,
      'city': city,
    };
  }

  @override
  String toString() {
    return 'Area{province: $province,  city: $city, }';
  }
}

class AreaLocal {
  int? id;
  String? province;
  String? city;

  AreaLocal({this.id, this.province, this.city});

  AreaLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province = json['province'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['province'] = province;
    data['city'] = city;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'province': province,
      'city': city,
    };
  }

  @override
  String toString() {
    return 'Area{id: $id, province: $province,  city: $city, }';
  }
}
