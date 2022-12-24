import 'package:flutter/material.dart';

class SearchBarView extends StatefulWidget {
  final Function(String) searchOnTap;
  const SearchBarView({
    Key? key,
    required this.searchOnTap,
  }) : super(key: key);

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: TextField(
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF000000), width: 3.0)),
                      hintText: 'Search',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(15),
                        width: 18,
                        child: const Icon(Icons.search),
                      )),
                  onChanged: widget.searchOnTap,
                ),
              ),
              // Container(
              //     margin: const EdgeInsets.only(right: 20),
              //     padding: const EdgeInsets.all(10),
              //     width: 20,
              //     child: TextButton(
              //         onPressed: () {},
              //         child: const Icon(
              //           Icons.filter_alt_outlined,
              //           size: 36,
              //           semanticLabel: 'Filter',
              //         ))),
            ],
          )
        ],
      ),
    );
  }
}
