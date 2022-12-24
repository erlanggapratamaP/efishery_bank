import 'package:efishery_bank/helpers/styles.dart';
import 'package:efishery_bank/view/ui/add_fish_view.dart';
import 'package:efishery_bank/viewmodel/fish_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helper.dart';
import '../widgets/filter_dialog_view.dart';
import '../widgets/searchbar_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    Provider.of<FishViewModel>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingAddWidget(context),
      body: Column(
        children: <Widget>[
          SizedBox(height: 120, child: titleApps()),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Consumer<FishViewModel>(
              builder: (context, fish, child) {
                return SearchBarView(
                  searchOnTap: (val) async {
                    setState(() {});
                    await fish.searchPriceFish(val.toLowerCase(), context);
                  },
                );
              },
            ),
          ),
          Consumer<FishViewModel>(builder: (context, fish, child) {
            return fish.isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Expanded(
                    child: showListFishPrice(context),
                  );
          }),
        ],
      ),
    );
  }

  Widget titleApps() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Best Place',
                  style: Styles().extraBigSizeBoldText(Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'to Find Fish',
                  style: Styles().bigSizeText(Colors.black),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.blue,
                size: 24,
                semanticLabel: 'Filter',
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'filter',
                    child: Text('Filter'),
                  ),
                  const PopupMenuItem(
                    value: 'sort',
                    child: Text('Sort'),
                  )
                ];
              },
              onSelected: (String value) => actionPopUpItemSelected(value),
            ),
          )
        ],
      ),
    );
  }

  void actionPopUpItemSelected(String value) {
    if (value == 'filter') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Consumer<FishViewModel>(builder: (context, fish, child) {
              return FilterDialogView(
                filterOnTap: () {
                  if (fish.minPrice >= 0 && fish.maxPrice > fish.minPrice) {
                    fish.filterPriceFish(context);
                    //reload view
                    setState(() {});
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Min Price dan Max Price belum sesuai')),
                    );
                  }
                },
              );
            });
          });
    } else if (value == 'sort') {
      setState(() {
        Provider.of<FishViewModel>(context, listen: false).isLoading = true;
      });
      Provider.of<FishViewModel>(context, listen: false).sortPriceFish(context);
    }
  }

  Widget showListFishPrice(context) {
    return Consumer<FishViewModel>(builder: (context, fish, child) {
      return RefreshIndicator(
        onRefresh: (() => fish.getListFish()),
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(fish.fishes[index].komoditas ?? '',
                              style: Styles().normalSizeBoldText(Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.convertToIdr(
                                fish.fishes[index].price ?? '0', 0),
                            style: Styles().smallSizeText(Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, bottom: 20, top: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('${fish.fishes[index].size ?? ''} gr'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            fish.fishes[index].areaKota ?? '',
                            style: Styles().extraSmallSizeText(Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            fish.fishes[index].areaProvinsi ?? '',
                            style: Styles().extraSmallSizeText(Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            }),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: fish.fishes.length),
      );
    });
  }

  Widget floatingAddWidget(context) {
    return Consumer<FishViewModel>(builder: (context, fish, child) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFishView()),
          ).whenComplete(() {
            setState(() {});
            fish.getListFish();
          });
        },
        child: const Icon(Icons.add),
      );
    });
  }
}
