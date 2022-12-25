import 'package:efishery_bank/helpers/helper.dart';
import 'package:efishery_bank/model/fish.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../viewmodel/add_fish_viewmodel.dart';

class AddFishView extends StatefulWidget {
  const AddFishView({super.key});

  @override
  State<AddFishView> createState() => _AddFishViewState();
}

class _AddFishViewState extends State<AddFishView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Provider.of<AddFishViewModel>(context, listen: false).initAdd();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFishViewModel>(builder: (context, fish, child) {
      return fish.isLoadingAdd
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  "Add Fish Price",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                centerTitle: true,
              ),
              body: Container(
                padding: const EdgeInsets.only(top: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: Consumer<AddFishViewModel>(
                              builder: (context, fish, child) {
                                return TextFormField(
                                  controller: fish.komoditasController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Komoditas'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                );
                              },
                            )),
                      ),
                      Container(
                        height: 60,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 25),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: Consumer<AddFishViewModel>(
                              builder: (context, fish, child) {
                                return TextFormField(
                                  controller: fish.priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      prefix: Text('Rp. '),
                                      border: InputBorder.none,
                                      labelText: 'Harga'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    var valTemp = value;
                                    valTemp = Helper().formatNumber(
                                        valTemp.replaceAll('.', ''));
                                    fish.priceController.value =
                                        TextEditingValue(
                                      text: valTemp,
                                      selection: TextSelection.collapsed(
                                          offset: valTemp.length),
                                    );
                                  },
                                );
                              },
                            )),
                      ),
                      Container(
                        height: 60,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 25),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: Consumer<AddFishViewModel>(
                                builder: (context, fish, child) {
                              return DropdownButtonFormField<String>(
                                isExpanded: true,
                                hint: const Text('Size'),
                                value: fish.valueSize,
                                elevation: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    fish.valueSize = value!;
                                  });
                                },
                                items: fish.sizeList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            })),
                      ),
                      Container(
                        height: 60,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 25),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5),
                          child: Consumer<AddFishViewModel>(
                            builder: (context, fish, child) {
                              return DropdownButtonFormField<String>(
                                isExpanded: true,
                                hint: const Text('Provinsi'),
                                value: fish.valueProvinsi,
                                elevation: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                onChanged: (String? value) async {
                                  setState(() {
                                    fish.getKotaByProv(value!);
                                    fish.valueProvinsi = value;
                                    fish.valueKota = null;
                                    fish.kotaList = [];
                                  });
                                },
                                items: fish.provinsiList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 25),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: Consumer<AddFishViewModel>(
                              builder: (context, fish, child) {
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  hint: const Text('Kota'),
                                  value: fish.valueKota,
                                  elevation: 16,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      fish.valueKota = value!;
                                    });
                                  },
                                  items: fish.kotaList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                );
                              },
                            )),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                              width: double.infinity,
                              height: 50,
                              margin: const EdgeInsets.only(
                                  left: 50, right: 50, top: 25, bottom: 100),
                              child: Consumer<AddFishViewModel>(
                                builder: (context, fish, child) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        const uuid = Uuid();
                                        var id = uuid.v4();
                                        //timestamp
                                        int timestamp = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        String cdate =
                                            DateFormat("yyyy-MM-dd:HH:mm:ss")
                                                .format(DateTime.now());
                                        Fish addFish = Fish(
                                            uuid: id,
                                            komoditas:
                                                fish.komoditasController.text,
                                            price: fish.priceController.text
                                                .replaceAll('.', ''),
                                            size: fish.valueSize,
                                            areaProvinsi: fish.valueProvinsi,
                                            areaKota: fish.valueKota,
                                            tglParsed: cdate,
                                            timestamp: timestamp.toString());
                                        fish.addListFish(addFish, context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Save'),
                                  );
                                },
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
