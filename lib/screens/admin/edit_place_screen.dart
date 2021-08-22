import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/app_constant.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/image_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/services/apis/admins/crud_places_api.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/services/images/image_picker_service.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

enum EditPlaceFlowType {
  edit,
  create,
}

class EditPlaceScreen extends StatefulWidget {
  const EditPlaceScreen({
    Key? key,
    this.place,
    this.onDeletePlace,
  }) : super(key: key);

  /// if place == null, this screen will be for create new place
  /// else for edit place
  final PlaceModel? place;

  /// call api to delete place
  final void Function()? onDeletePlace;

  @override
  _EditPlaceScreenState createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> with CgMediaQueryMixin, CgThemeMixin {
  late PlaceModel place;
  late CambodiaGeography geo;

  List<ImageProvider> images = [];
  List<String> provinces = [];
  List<String> districts = [];
  List<String> communes = [];
  List<String> villages = [];

  late EditPlaceFlowType flowType;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    place = PlaceModel.empty();
    place = widget.place ?? this.place;
    setFlowType();
    setInitGeoItems();
    setInitImages();
    super.initState();
  }

  void setFlowType() {
    if (widget.place?.id != null) {
      flowType = EditPlaceFlowType.edit;
    } else {
      flowType = EditPlaceFlowType.create;
    }
  }

  void setInitGeoItems() {
    if (place.provinceCode != null) {
      setDistrict(place.provinceCode);
      if (place.districtCode != null) {
        setCommunes(place.districtCode);
        if (place.communeCode != null) setVillages(place.communeCode);
      }
      setInitialGeoValue();
    }
  }

  void setInitImages() {
    place.images?.forEach((image) {
      if (image.url != null) {
        this.images.add(CachedNetworkImageProvider(image.url!));
      }
    });
  }

  Future<void> onSave() async {
    CrudPlacesApi api = CrudPlacesApi();
    App.of(context)?.showLoading();
    List<File> images = await _getFilesFromImages();

    switch (flowType) {
      case EditPlaceFlowType.create:
        await api.createAPlace(images: images, place: place);
        break;
      case EditPlaceFlowType.edit:
        await api.updatePlace(
          images: images,
          place: place,
          removeImages: removeImages,
        );
        break;
    }

    App.of(context)?.hideLoading();
    if (api.success()) {
      Navigator.of(context).pop(place);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(api.message() ?? "Please try again!"),
        ),
      );
    }
  }

  Future<File?> _getCacheFile(String imageUrl) async {
    DefaultCacheManager cache = DefaultCacheManager();
    try {
      File file = await cache.getSingleFile(imageUrl);
      return file;
    } catch (e) {
      FileInfo fileInfo = await cache.downloadFile(imageUrl);
      return fileInfo.file;
    }
  }

  List<String> removeImages = [];

  Future<List<File>> _getFilesFromImages() async {
    List<File> files = [];
    removeImages = [];

    for (var image in images) {
      if (image is FileImage) files.add(image.file);
      if (image is CachedNetworkImageProvider) {
        File? file = await _getCacheFile(image.url);
        if (file != null) files.add(file);
        List<ImageModel>? imagesToDelete = widget.place?.images?.where((_image) => _image.url == image.url).toList();
        if (imagesToDelete?.isNotEmpty == true && imagesToDelete?.first.id != null) {
          removeImages.add(imagesToDelete!.first.id!);
        }
      }
    }

    if (files.isEmpty) removeImages = widget.place?.images?.map((e) => "${e.id}").toList() ?? [];
    return files;
  }

  String? provinceInitValue;
  String? districtInitValue;
  String? communesInitValue;
  String? villagesInitValue;

  void setInitialGeoValue() {
    List<TbVillageModel> _village =
        CambodiaGeography.instance.tbVillages.where((element) => place.villageCode == element.code).toList();
    villagesInitValue = _village.isNotEmpty && villages.isNotEmpty
        ? _village.first.khmer.toString() + " (${_village.first.code.toString()})"
        : null;

    List<TbCommuneModel> _communes =
        CambodiaGeography.instance.tbCommunes.where((element) => place.communeCode == element.code).toList();
    communesInitValue = _communes.isNotEmpty && communes.isNotEmpty
        ? _communes.first.khmer.toString() + " (${_communes.first.code.toString()})"
        : null;

    List<TbDistrictModel> _districts =
        CambodiaGeography.instance.tbDistricts.where((element) => place.districtCode == element.code).toList();
    districtInitValue = _districts.isNotEmpty && districts.isNotEmpty
        ? _districts.first.khmer.toString() + " (${_districts.first.code.toString()})"
        : null;

    List<TbProvinceModel> _provinces =
        CambodiaGeography.instance.tbProvinces.where((element) => place.provinceCode == element.code).toList();
    provinceInitValue =
        _provinces.isNotEmpty ? _provinces.first.khmer.toString() + " (${_provinces.first.code.toString()})" : null;
  }

  void clearInitialValue() {
    this.villagesInitValue = null;
    this.communesInitValue = null;
    this.districtInitValue = null;
    this.provinceInitValue = null;
  }

  void setDistrict(String? _provinceCode) {
    clearInitialValue();
    this.place = this.place.copyWith(provinceCode: _provinceCode);
    var result = geo.districtsSearch(provinceCode: _provinceCode.toString());
    districts = result.map((e) => e.khmer.toString() + " (${e.code})").toList();
  }

  void setCommunes(String? _districtCode) {
    clearInitialValue();
    this.place = this.place.copyWith(districtCode: _districtCode);
    var result = geo.communesSearch(districtCode: _districtCode.toString());
    communes = result.map((e) => e.khmer.toString() + " (${e.code})").toList();
  }

  void setVillages(String? _communeCode) {
    clearInitialValue();
    this.place = this.place.copyWith(communeCode: _communeCode);
    var result = geo.villagesSearch(communeCode: _communeCode.toString());
    villages = result.map((e) => e.khmer.toString() + " (${e.code})").toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        PlaceModel initPlace = widget.place ?? PlaceModel.empty();
        Map<String, dynamic> initPlaceMap = AppHelper.filterOutNull(initPlace.toJson());
        Map<String, dynamic> placeMap = AppHelper.filterOutNull(place.toJson());

        bool didNoUpdate = "$initPlaceMap" == "$placeMap";
        bool didUpdate = !didNoUpdate;

        List<String> initialImages = [];
        List<String?> images = widget.place?.images?.map((e) => e.url).toList() ?? [];

        this.images.forEach((image) {
          if (image is CachedNetworkImageProvider) {
            initialImages.add(image.url);
          }
          if (image is FileImage) {
            initialImages.add(image.file.path);
          }
        });

        bool didNotChangeImages = listEquals(initialImages, images);
        bool didChangeImages = !didNotChangeImages;

        if (didUpdate) {
          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: "Discard changes?",
            message: place.khmer,
            okLabel: "Discard",
          );
          if (result == OkCancelResult.ok) Navigator.of(context).pop();
        } else if (didChangeImages) {
          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: "Discard changes?",
            message: "Some images are updated",
            okLabel: "Discard",
          );
          if (result == OkCancelResult.ok) Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        floatingActionButton: buildSaveButton(),
        appBar: MorphingAppBar(
          title: CgAppBarTitle(title: widget.place == null ? "បន្ថែម" : "ផ្លាស់ប្តូ"),
        ),
        body: ListView(
          children: [
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              title: "អំពីរទីតាំង",
              children: [
                buildPlaceTypeDropDownField(),
                buildProvinceDropDownField(),
                if (districts.isNotEmpty) buildDistrictDropDownField(),
                if (communes.isNotEmpty) buildCommunesDropDownField(),
                if (villages.isNotEmpty) buildVillageDropDownField(),
                buildKhmerField(),
                buildEnglishField(),
                buildBodyButton(),
              ],
            ),
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              title: "ផែនទី",
              children: [
                buildMapButton(),
              ],
            ),
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              padding: EdgeInsets.zero,
              title: "រូបភាព",
              children: [
                buildImagePickerField(),
              ],
            ),
            const SizedBox(height: ConfigConstant.margin2),
            if (widget.onDeletePlace != null) buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
      alignment: Alignment.centerLeft,
      child: CgButton(
        labelText: "លុបទីតាំង",
        iconData: Icons.delete,
        backgroundColor: colorScheme.error.withOpacity(0.1),
        foregroundColor: colorScheme.error,
        showBorder: true,
        onPressed: widget.onDeletePlace,
      ),
    );
  }

  Widget buildSectionWrapper({
    required List<Widget> children,
    EdgeInsets padding = const EdgeInsets.all(ConfigConstant.margin2),
    String? title,
  }) {
    if (title != null) {
      children.insertAll(0, [
        SizedBox(height: padding.top == 0 ? ConfigConstant.margin1 : 0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding.left == 0 ? ConfigConstant.margin2 : 0),
          child: Text(title, style: textTheme.subtitle1),
        ),
      ]);
    }

    return Container(
      color: colorScheme.surface,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget buildEnglishField() {
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgTextField(
        labelText: "ឈ្មោះទីតាំង (ឡាតាំង)",
        fillColor: colorScheme.background,
        value: place.english,
        onChanged: (String value) {
          this.place = this.place.copyWith(english: value);
        },
      ),
    );
  }

  Widget buildKhmerField() {
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgTextField(
        labelText: "ឈ្មោះទីតាំង",
        fillColor: colorScheme.background,
        value: place.khmer,
        onChanged: (String value) {
          this.place = this.place.copyWith(khmer: value);
        },
      ),
    );
  }

  Widget buildBodyButton() {
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      color: colorScheme.surface,
      child: Material(
        color: colorScheme.background,
        borderRadius: ConfigConstant.circlarRadius1,
        child: ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right),
          shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
          title: Text(
            "អំពីរទីតាំង",
            style: textTheme.bodyText1?.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            place.body?.isNotEmpty == true ? place.body! : "មិនមានទិន្នន័យ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            await Navigator.pushNamed(
              context,
              RouteConfig.BODY_EDITOR,
              arguments: place.body ?? "",
            ).then((body) {
              if (body is String) {
                setState(() {
                  this.place = this.place.copyWith(body: body);
                });
              }
            });
          },
        ),
      ),
    );
  }

  Widget buildMapButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("latitude: ${place.lat}", style: textTheme.caption),
        Text("longtitude: ${place.lon}", style: textTheme.caption),
        const SizedBox(height: ConfigConstant.margin1),
        CgButton(
          labelText: "ជ្រើសទីតាំង",
          iconData: Icons.map,
          backgroundColor: colorScheme.secondary.withOpacity(0.1),
          foregroundColor: colorScheme.secondary,
          showBorder: true,
          onPressed: () async {
            LatLng? latLng;
            if (place.lat != null && place.lon != null) {
              latLng = LatLng(place.lat!, place.lon!);
            }
            Navigator.pushNamed(
              context,
              RouteConfig.MAP,
              arguments: MapScreenSetting(flowType: MapFlowType.pick, initialLatLng: latLng),
            ).then(
              (value) {
                if (value is LatLng) {
                  setState(() {
                    this.place = this.place.copyWith(lat: value.latitude, lon: value.longitude);
                  });
                }
              },
            );
          },
        )
      ],
    );
  }

  Widget buildPlaceTypeDropDownField() {
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgDropDownField(
        labelText: "ប្រភេទទីតាំង",
        key: Key(AppContant.placeType.join("")),
        items: AppContant.placeType,
        initValue: place.type,
        onChanged: (String? value) {
          if (value == null) return;
          this.place = this.place.copyWith(type: value);
        },
      ),
    );
  }

  Widget buildVillageDropDownField() {
    List<String> items = ["null", ...villages];
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgDropDownField(
        initValue: items.contains(villagesInitValue) ? villagesInitValue : null,
        labelText: "ភូមិ",
        fillColor: colorScheme.background,
        key: Key(villages.join()),
        items: items,
        onChanged: (value) {
          if (value == "null") {
            setState(() {
              this.place.clearVillageCode();
            });
            return;
          }
          setState(() {
            var selectedVillage = geo.tbVillages.where((e) => value?.contains(e.khmer.toString()) == true).toList();
            var _villageCode = selectedVillage.first.code;
            this.place = this.place.copyWith(villageCode: _villageCode);
          });
        },
      ),
    );
  }

  Widget buildCommunesDropDownField() {
    List<String> items = ["null", ...communes];
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgDropDownField(
        initValue: items.contains(communesInitValue) ? communesInitValue : null,
        labelText: "ឃុំ",
        fillColor: colorScheme.background,
        key: Key(communes.join()),
        items: [
          "null",
          ...communes,
        ],
        onChanged: (value) {
          villages.clear();
          if (value == "null") {
            setState(() {
              this.place.clearCommuneCode();
              this.place.clearVillageCode();
            });
            return;
          }
          setState(() {
            var selectedCommune = geo.tbCommunes.where((e) => value?.contains(e.khmer.toString()) == true).toList();
            var _communeCode = selectedCommune.first.code;
            setVillages(_communeCode);
          });
        },
      ),
    );
  }

  Widget buildDistrictDropDownField() {
    List<String> items = ["null", ...districts];
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgDropDownField(
        initValue: items.contains(districtInitValue) ? districtInitValue : null,
        labelText: "ស្រុក",
        key: Key(districts.join()),
        items: [
          "null",
          ...districts,
        ],
        onChanged: (value) {
          villages.clear();
          communes.clear();

          if (value == "null") {
            setState(() {
              this.place.clearDistrictCode();
              this.place.clearCommuneCode();
              this.place.clearVillageCode();
            });
            return;
          }

          setState(() {
            var selectedDistrict = geo.tbDistricts.where((e) => value?.contains(e.khmer.toString()) == true).toList();
            var _districtCode = selectedDistrict.first.code;
            setCommunes(_districtCode);
          });
        },
      ),
    );
  }

  Widget buildProvinceDropDownField() {
    List<String> items = geo.tbProvinces.map((e) => e.khmer.toString() + " (${e.code.toString()})").toList();
    return Container(
      margin: const EdgeInsets.only(top: ConfigConstant.margin1),
      child: CgDropDownField(
        labelText: "ស្ថិតនៅខេត្ត",
        initValue: items.contains(provinceInitValue) ? provinceInitValue : null,
        items: items,
        onChanged: (value) {
          districts.clear();
          communes.clear();
          setState(() {
            var selectedProvince = geo.tbProvinces.where((e) => value?.contains(e.khmer.toString()) == true).toList();
            var _provinceCode = selectedProvince.first.code;
            setDistrict(_provinceCode);
          });
        },
      ),
    );
  }

  Widget buildSaveButton() {
    return FloatingActionButton(
      child: Icon(Icons.save),
      onPressed: () => onSave(),
    );
  }

  Widget buildImagePickerField() {
    return Container(
      height: 87 + 16 + 8,
      child: ListView.separated(
        itemCount: images.length + 1,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(ConfigConstant.margin2).copyWith(top: ConfigConstant.margin0),
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: ConfigConstant.margin1,
          );
        },
        itemBuilder: (context, _index) {
          if (_index == 0) {
            return Material(
              color: colorScheme.background,
              borderRadius: ConfigConstant.circlarRadius1,
              child: InkWell(
                borderRadius: ConfigConstant.circlarRadius1,
                onTap: () async {
                  File? file = await ImagePickerService.pickImage();
                  if (file != null) {
                    setState(() {
                      images.add(FileImage(file));
                    });
                  }
                },
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Icon(Icons.add_a_photo),
                ),
              ),
            );
          }

          int index = _index - 1;
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: ConfigConstant.circlarRadius1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: images[index]),
                    ),
                  ),
                ),
                buildImageDeleteButton(
                  tooltipMessage: "Delete",
                  onPressed: () {
                    setState(() {
                      images.remove(images[index]);
                    });
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildImageDeleteButton({
    required void Function() onPressed,
    required String tooltipMessage,
  }) {
    return Positioned(
      top: ConfigConstant.margin1,
      right: ConfigConstant.margin1,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.onError.withOpacity(0.5),
        ),
        child: IconButton(
          tooltip: tooltipMessage,
          color: colorScheme.error,
          iconSize: ConfigConstant.iconSize1,
          icon: Icon(Icons.delete),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
