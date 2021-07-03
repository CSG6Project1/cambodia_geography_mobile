import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.geo,
  }) : super(key: key);

  final CambodiaGeography geo;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? currentProvinceCode;

  @override
  void initState() {
    super.initState();
    currentProvinceCode = widget.geo.tbProvinces[0].code;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: widget.geo.tbProvinces.length,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.map),
                Text("Cambodia Geography"),
              ],
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: List.generate(
                widget.geo.tbProvinces.length,
                (index) => Tab(
                  child: Text(
                    widget.geo.tbProvinces[index].khmer.toString(),
                  ),
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            children: List.generate(
              widget.geo.tbProvinces.length,
              (index) {
                final province = widget.geo.tbProvinces[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(province.khmer.toString()),
                    Material(
                      elevation: 0.5,
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(province.toJson().toString()),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
        ),

        // body: ListView(
        //   children: List.generate(
        //     widget.geo.tbProvinces.length,
        //     (index) {
        //       final province = widget.geo.tbProvinces[index];
        //       final districts = widget.geo.districtsSearch(provinceCode: province.code.toString());

        //       return Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: List.generate(
        //           districts.length,
        //           (index) {
        //             final district = districts[index];
        //             final communes = widget.geo.communesSearch(districtCode: district.code.toString());

        //             return ExpansionTile(
        //               title: Text(district.khmer.toString()),
        //               expandedAlignment: Alignment.centerLeft,
        //               expandedCrossAxisAlignment: CrossAxisAlignment.start,
        //               children: List.generate(
        //                 communes.length,
        //                 (index) {
        //                   return ListTile(
        //                     title: Text(communes[index].khmer.toString()),
        //                     subtitle: Text(communes[index].code.toString()),
        //                   );
        //                 },
        //               ),
        //             );
        //           },
        //         )..insert(
        //             0,
        //             Container(
        //               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //               color: Theme.of(context).colorScheme.primary,
        //               width: double.infinity,
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     province.khmer.toString(),
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .subtitle1
        //                         ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //       );
        //     },
        //   ),
        // ),
        // ),
      ),
    );
  }
}
