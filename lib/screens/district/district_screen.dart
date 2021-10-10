import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class GeoModel {
  TbProvinceModel? province;
  TbDistrictModel? district;
  TbCommuneModel? commune;
  TbVillageModel? village;

  GeoModel({
    this.province,
    this.district,
    this.commune,
    this.village,
  });
}

class DistrictScreen extends StatefulWidget {
  const DistrictScreen({
    Key? key,
    required this.geo,
  }) : super(key: key);

  final GeoModel geo;

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> with CgThemeMixin, CgMediaQueryMixin {
  late AutoScrollController scrollController;
  late TbDistrictModel district;
  late List<TbCommuneModel> communes;

  late String initialCode;

  String getTitle() {
    if (district.type == "KRONG") {
      return tr('geo.krong_name', namedArgs: {
        'KRONG': district.nameTr ?? "",
      });
    }
    if (district.type == "KHAN") {
      return tr('geo.khan_name', namedArgs: {
        'KHAN': district.nameTr ?? "",
      });
    }
    if (district.type == "SROK") {
      return tr('geo.srok_name', namedArgs: {
        'SROK': district.nameTr ?? "",
      });
    }
    return '';
  }

  GeoModel get geo => widget.geo;

  @override
  void initState() {
    scrollController = AutoScrollController();
    super.initState();

    district = geo.district!;
    initialCode = geo.village?.code ?? geo.commune?.code ?? district.code!;

    communes = CambodiaGeography.instance.communesSearch(districtCode: district.code.toString());

    initPosition();
  }

  void initPosition() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      try {
        int index = communes.indexWhere((e) {
          return shouldExpandCommune(
            e.code ?? "",
            CambodiaGeography.instance.villagesSearch(communeCode: e.code ?? ""),
          );
        });

        AutoScrollPosition preferPosition = AutoScrollPosition.begin;

        try {
          if (geo.village != null) {
            List<TbVillageModel> villages =
                CambodiaGeography.instance.villagesSearch(communeCode: communes[index].code!);
            int villageIndex = villages.indexWhere((e) => geo.village?.code == e.code);

            double perPosition = villages.length / 3;
            if (villageIndex >= perPosition * 2) {
              preferPosition = AutoScrollPosition.end;
            } else if (villageIndex >= perPosition) {
              preferPosition = AutoScrollPosition.middle;
            } else if (villageIndex >= 0) {
              preferPosition = AutoScrollPosition.begin;
            }
          }
        } catch (e) {}

        scrollController.scrollToIndex(
          index,
          preferPosition: preferPosition,
        );
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: MorphingAppBar(
        title: GestureDetector(
          onLongPress: () {
            showInfoModalBottomSheet(
              context,
              district.toJson(),
            );
          },
          child: CgAppBarTitle(title: getTitle()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            tooltip: tr('title.reference'),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteConfig.REFERENCE);
            },
          ),
        ],
      ),
      body: buildCommuneList(communes: communes),
    );
  }

  Widget buildCommuneList({
    required List<TbCommuneModel> communes,
  }) {
    CambodiaGeography geo = CambodiaGeography.instance;
    return ListView.builder(
      padding: EdgeInsets.only(
        top: ConfigConstant.margin1,
        bottom: mediaQueryData.padding.bottom + ConfigConstant.margin2,
      ),
      itemCount: communes.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        TbCommuneModel commune = communes[index];
        List<TbVillageModel> villages = geo.villagesSearch(communeCode: commune.code.toString());
        return buildCommuneTile(
          commune: commune,
          villages: villages,
          isFirstIndex: index == 0,
          isLastIndex: index == communes.length - 1,
          index: index,
        );
      },
    );
  }

  bool shouldExpandCommune(String communeCode, List<TbVillageModel> villages) {
    return initialCode == communeCode || villages.map((e) => e.code).toList().contains(initialCode);
  }

  Widget buildCommuneTile({
    required TbCommuneModel commune,
    required List<TbVillageModel> villages,
    required int index,
    bool isFirstIndex = false,
    bool isLastIndex = false,
  }) {
    String communeTitle = "";

    if (commune.type == "SANGKAT") {
      communeTitle = tr(
        'geo.sangkat_name',
        namedArgs: {
          'SANGKAT': commune.nameTr.toString(),
        },
      );
    }

    if (commune.type == "COMMUNE") {
      communeTitle = tr(
        'geo.commune_name',
        namedArgs: {
          'COMMUNE': commune.nameTr.toString(),
        },
      );
    }

    bool _shouldExpandCommune = shouldExpandCommune(commune.code ?? "", villages);
    return GestureDetector(
      onLongPress: () {
        showInfoModalBottomSheet(
          context,
          commune.toJson(),
        );
      },
      child: AutoScrollTag(
        controller: scrollController,
        key: ValueKey(index),
        index: index,
        child: ToggleValueBuilder(
          initialValue: _shouldExpandCommune,
          builder: (context, valueNotifier) {
            return ValueListenableBuilder(
              child: buildExpansonTile(
                valueNotifier,
                index,
                communeTitle,
                commune,
                villages,
                _shouldExpandCommune,
              ),
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                double padding = value == false ? ConfigConstant.margin2 : 0;
                return AnimatedContainer(
                  curve: Curves.ease,
                  duration: ConfigConstant.fadeDuration,
                  margin: EdgeInsets.only(
                    top: 4.0,
                    bottom: 4.0,
                    left: padding,
                    right: padding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(value == false ? ConfigConstant.radius1 : 0),
                    color: themeData.colorScheme.surface,
                  ),
                  child: Theme(
                    data: themeData.copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                    ),
                    child: Card(
                      child: child,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildExpansonTile(
    ValueNotifier<dynamic> valueNotifier,
    int index,
    String communeTitle,
    TbCommuneModel commune,
    List<TbVillageModel> villages,
    bool shouldExpandCommune,
  ) {
    return ExpansionTile(
      initiallyExpanded: shouldExpandCommune,
      tilePadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      onExpansionChanged: (bool value) {
        valueNotifier.value = value;
        if (value == true) {
          Future.delayed(ConfigConstant.duration).then((value) async {
            scrollController.scrollToIndex(index);
          });
        }
      },
      title: Text(
        communeTitle,
        style:
            themeData.textTheme.headline6?.copyWith(color: themeData.colorScheme.primary, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        numberTr(tr(
          'geo.postal_code',
          namedArgs: {'CODE': commune.code.toString()},
        )),
        style: TextStyle(
          color: themeData.colorScheme.onSurface,
        ),
      ),
      children: buildVillageList(
        commune: commune,
        context: context,
        villages: villages,
      ),
    );
  }

  List<Widget> buildVillageList({
    required TbCommuneModel commune,
    required BuildContext context,
    required List<TbVillageModel> villages,
  }) {
    return List.generate(villages.length, (index) {
      String title = tr(
        'geo.village_name',
        namedArgs: {
          'VILLAGE': villages[index].nameTr.toString().replaceAll("ភូមិ", ""),
        },
      );

      bool isSelected = initialCode == villages[index].code;
      Widget child = ListTile(
        onTap: () {
          showInfoModalBottomSheet(
            context,
            villages[index].toJson(),
          );
        },
        onLongPress: () {
          showInfoModalBottomSheet(
            context,
            villages[index].toJson(),
          );
        },
        title: Text(title),
        subtitle: Text(
          numberTr(tr(
            'geo.postal_code',
            namedArgs: {'CODE': villages[index].code.toString()},
          )),
        ),
      );

      return TweenAnimationBuilder<Color?>(
        duration: ConfigConstant.duration * 5,
        tween: ColorTween(
          begin: isSelected ? themeData.splashColor : colorScheme.surface,
          end: colorScheme.surface,
        ),
        child: child,
        builder: (context, color, widget) {
          return Material(
            color: color,
            child: widget,
          );
        },
      );
    });
  }
}

class ToggleValueBuilder extends StatefulWidget {
  const ToggleValueBuilder({
    Key? key,
    required this.builder,
    required this.initialValue,
  }) : super(key: key);

  final dynamic initialValue;
  final Widget Function(
    BuildContext context,
    ValueNotifier notifier,
  ) builder;

  @override
  _ToggleValueBuilderState createState() => _ToggleValueBuilderState();
}

class _ToggleValueBuilderState<T> extends State<ToggleValueBuilder> {
  late ValueNotifier valueNotifier;

  @override
  void initState() {
    valueNotifier = ValueNotifier(widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      valueNotifier,
    );
  }
}

Future<dynamic> showInfoModalBottomSheet(
  BuildContext context,
  Map<String, dynamic> json,
) {
  List<String> excepts = ['image'];
  List<MapEntry<String, dynamic>> value = json.entries.where((e) {
    return e.value != null && !excepts.contains(e.key);
  }).toList();
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadiusTop1),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            tr('title.information'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          automaticallyImplyLeading: false,
          actions: [CloseButton(color: Theme.of(context).colorScheme.onSurface)],
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
        ),
        body: ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            var item = value[index];
            ReCase recase = ReCase(item.key);
            return Material(
              color: Theme.of(context).colorScheme.surface,
              child: ListTile(
                title: Text(recase.titleCase),
                subtitle: Text("${item.value}"),
              ),
            );
          },
        ),
      );
    },
  );
}
