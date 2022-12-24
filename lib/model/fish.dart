class Fish {
  String? uuid;
  String? komoditas;
  String? areaProvinsi;
  String? areaKota;
  String? size;
  String? price;
  String? tglParsed;
  String? timestamp;

  Fish(
      {this.uuid,
      this.komoditas,
      this.areaProvinsi,
      this.areaKota,
      this.size,
      this.price,
      this.tglParsed,
      this.timestamp});

  Fish.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    komoditas = json['komoditas'];
    areaProvinsi = json['area_provinsi'];
    areaKota = json['area_kota'];
    size = json['size'];
    price = json['price'];
    tglParsed = json['tgl_parsed'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['komoditas'] = komoditas;
    data['area_provinsi'] = areaProvinsi;
    data['area_kota'] = areaKota;
    data['size'] = size;
    data['price'] = price;
    data['tgl_parsed'] = tglParsed;
    data['timestamp'] = timestamp;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'komoditas': komoditas,
      'area_provinsi': areaProvinsi,
      'area_kota': areaKota,
      'size': size,
      'price': price,
      'tgl_parsed': tglParsed,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'Fish{uuid: $uuid, komoditas: $komoditas, area_provinsi: $areaProvinsi, area_kota: $areaKota, size: $size, price: $price, tgl_parsed: $tglParsed, timestamp: $timestamp}';
  }
}
