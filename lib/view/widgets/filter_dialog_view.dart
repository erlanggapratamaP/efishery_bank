import 'package:efishery_bank/viewmodel/fish_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/helper.dart';

class FilterDialogView extends StatefulWidget {
  final VoidCallback? filterOnTap;
  const FilterDialogView({
    Key? key,
    this.filterOnTap,
  }) : super(key: key);

  @override
  State<FilterDialogView> createState() => _FilterDialogViewState();
}

class _FilterDialogViewState extends State<FilterDialogView> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            height: height - 600,
            width: width - 60,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.only(), child: Text('Range Price')),
                  Consumer<FishViewModel>(
                    builder: (context, fish, child) {
                      return RangeSlider(
                        values: fish.currentRangeValues,
                        min: 0,
                        max: 1000000,
                        divisions: 5,
                        labels: RangeLabels(
                            Helper.convertToIdr(
                                fish.currentRangeValues.start
                                    .round()
                                    .toString(),
                                0),
                            Helper.convertToIdr(
                                fish.currentRangeValues.end.round().toString(),
                                0)),
                        onChanged: (RangeValues values) {
                          setState(() {
                            fish.currentRangeValues = values;
                            int intMin = values.start.toInt();
                            int intMax = values.end.toInt();
                            var valMin = intMin.toString();
                            var valMax = intMax.toString();
                            valMin = Helper()
                                .formatNumber(valMin.replaceAll('.', ''));
                            valMax = Helper()
                                .formatNumber(valMax.replaceAll('.', ''));
                            fish.minPrice = values.start;
                            fish.maxPrice = values.end;
                            fish.minPriceController.value = TextEditingValue(
                                text: valMin,
                                selection: TextSelection.collapsed(
                                    offset: valMin.length));
                            fish.maxPriceController.value = TextEditingValue(
                                text: valMax,
                                selection: TextSelection.collapsed(
                                    offset: valMax.length));
                          });
                        },
                      );
                    },
                  ),
                  const Text('Range Limit'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Consumer<FishViewModel>(
                            builder: (context, fish, child) {
                          return TextField(
                            controller: fish.minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: 'Rp. ',
                              border: OutlineInputBorder(),
                              labelText: 'Min Price',
                            ),
                            onChanged: (value) {
                              var valTemp = value;
                              valTemp = Helper()
                                  .formatNumber(valTemp.replaceAll('.', ''));
                              fish.minPriceController.value = TextEditingValue(
                                text: valTemp,
                                selection: TextSelection.collapsed(
                                    offset: valTemp.length),
                              );

                              setState(() {
                                fish.minPrice =
                                    double.parse(value.replaceAll('.', ''));
                                if (fish.minPrice < fish.maxPrice) {
                                  fish.currentRangeValues =
                                      RangeValues(fish.minPrice, fish.maxPrice);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Consumer<FishViewModel>(
                            builder: (context, fish, child) {
                          return TextField(
                            controller: fish.maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: 'Rp. ',
                              border: OutlineInputBorder(),
                              labelText: 'Max Price',
                            ),
                            onChanged: (value) {
                              var valTemp = value;
                              valTemp = Helper()
                                  .formatNumber(valTemp.replaceAll('.', ''));
                              fish.maxPriceController.value = TextEditingValue(
                                text: valTemp,
                                selection: TextSelection.collapsed(
                                    offset: valTemp.length),
                              );

                              setState(() {
                                fish.maxPrice =
                                    double.parse(value.replaceAll('.', ''));
                                if (fish.maxPrice > fish.minPrice) {
                                  fish.currentRangeValues =
                                      RangeValues(fish.minPrice, fish.maxPrice);
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      title: const Text('Filter'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: widget.filterOnTap,
          child: const Text('Set'),
        ),
      ],
    );
  }
}
