class SizeFish {
  String? size;

  SizeFish({this.size});

  SizeFish.fromJson(Map<String, dynamic> json) {
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
    };
  }

  @override
  String toString() {
    return 'SizeFish{size: $size}';
  }
}

class SizeFishLocal {
  int? id;
  String? size;

  SizeFishLocal({this.id, this.size});

  SizeFishLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['size'] = size;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'size': size,
    };
  }

  @override
  String toString() {
    return 'SizeFish{id: $id, size: $size}';
  }
}
