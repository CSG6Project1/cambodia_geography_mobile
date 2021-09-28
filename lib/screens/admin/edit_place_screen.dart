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
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/services/apis/admins/crud_places_api.dart';
import 'package:cambodia_geography/services/images/image_picker_service.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_filter_geo_fields.dart';
import 'package:easy_localization/easy_localization.dart';
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
  late EditPlaceFlowType flowType;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    place = widget.place ?? PlaceModel.empty();

    setFlowType();
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
          content: Text(api.message() ?? tr('msg.try_again')),
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
            title: tr('msg.discard_changes'),
            message: place.khmer,
            okLabel: tr('button.discard'),
          );
          if (result == OkCancelResult.ok) Navigator.of(context).pop();
        } else if (didChangeImages) {
          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: tr('msg.discard_changes'),
            message: tr('msg.images_are_updated'),
            okLabel: tr('button.discard'),
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
          title: CgAppBarTitle(title: widget.place == null ? tr('button.create') : tr('button.update')),
        ),
        body: ListView(
          children: [
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              title: tr('title.about_place'),
              children: [
                const SizedBox(height: ConfigConstant.margin0),
                CgFilterGeoFields(
                  isAdmin: true,
                  filter: place,
                  onChanged: (place) {
                    print(place.toJson());
                    this.place = place;
                  },
                ),
                buildKhmerField(),
                buildEnglishField(),
                buildBodyButton(),
              ],
            ),
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              title: tr('button.map'),
              children: [
                buildMapButton(),
              ],
            ),
            const SizedBox(height: ConfigConstant.margin2),
            buildSectionWrapper(
              padding: EdgeInsets.zero,
              title: tr('title.images'),
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
        labelText: tr('button.delete_place'),
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
          child: Text(
            title,
            style: textTheme.subtitle1,
            strutStyle: StrutStyle.fromTextStyle(textTheme.subtitle1!, forceStrutHeight: true),
          ),
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
        labelText: tr('hint.place_name_en'),
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
        labelText: tr('hint.place_name_km'),
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
            tr('title.about_place'),
            style: textTheme.bodyText1?.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            place.body?.isNotEmpty == true ? place.body! : tr('msg.no_data'),
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
        Text(
          tr('geo.lat_name', namedArgs: {'LAT': '${place.lat}'}),
          style: textTheme.caption,
        ),
        Text(
          tr('geo.lon_name', namedArgs: {'LON': '${place.lon}'}),
          style: textTheme.caption,
        ),
        const SizedBox(height: ConfigConstant.margin1),
        CgButton(
          labelText: tr('button.map'),
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
        labelText: tr('label.place_type'),
        key: Key(AppContant.placeType.join("")),
        items: AppContant.placeType.map((e) => CgDropDownFieldItem(label: e, value: e)).toList(),
        initValue: place.type,
        onChanged: (dynamic value) {
          if (value == null) return;
          this.place = this.place.copyWith(type: value);
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
                  tooltipMessage: tr('button.delete'),
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
