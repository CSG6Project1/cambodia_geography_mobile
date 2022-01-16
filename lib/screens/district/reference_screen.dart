import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({
    Key? key,
    required this.geo,
  }) : super(key: key);

  final GeoModel geo;

  @override
  _ReferenceScreenState createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> with CgThemeMixin, CgMediaQueryMixin {
  TbProvinceModel? province;

  @override
  void initState() {
    super.initState();

    if (widget.geo.province != null) {
      this.province = widget.geo.province;
    } else if (widget.geo.district?.code != null) {
      CambodiaGeography.instance.provinceByDistrictCode(widget.geo.district!.code!).then((value) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          setState(() {
            this.province = value;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        automaticallyImplyLeading: true,
        title: CgAppBarTitle(
          title: tr('title.reference'),
        ),
      ),
      body: ListView(
        children: [
          MaterialBanner(
            forceActionsBelow: true,
            backgroundColor: colorScheme.surface,
            leading: CircleAvatar(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              child: Icon(Icons.info),
            ),
            content: Text(tr('msg.data_collection_reference')),
            actions: [
              CgButton(
                labelText: tr('button.visit_their_reference'),
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                onPressed: () {
                  launch('https://geo.nestcode.co/references');
                },
              ),
            ],
          ),
          TweenAnimationBuilder<int>(
            duration: ConfigConstant.duration,
            tween: IntTween(begin: 0, end: 100),
            builder: (context, opacity, child) {
              return _CgOnTapEffect(
                effects: [
                  CgOnTapEffectType.scaleDown,
                ],
                onTap: () {
                  Navigator.of(context).pushNamed(RouteConfig.PROVINCE_DETAIL, arguments: province);
                },
                child: Opacity(
                  opacity: province == null ? 0 : opacity / 100,
                  child: Card(
                    color: colorScheme.secondary,
                    margin: EdgeInsets.all(ConfigConstant.margin2),
                    child: Padding(
                      padding: const EdgeInsets.all(ConfigConstant.margin2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  province?.nameTr ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.headline6?.copyWith(color: colorScheme.onSecondary),
                                ),
                                Text(
                                  numberTr(tr(
                                        'geo.postal_code',
                                        namedArgs: {'CODE': province?.code ?? ''},
                                      )) +
                                      tr('msg.and') +
                                      (province?.reference ?? ''),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: colorScheme.onSecondary.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: ConfigConstant.margin0),
                          Material(
                            elevation: 8.0,
                            child: province?.image != null
                                ? Image.asset(
                                    province!.image!,
                                    height: ConfigConstant.objectHeight4,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: ConfigConstant.objectHeight4,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum CgOnTapEffectType {
  touchableOpacity,
  scaleDown,
}

class _CgOnTapEffect extends StatefulWidget {
  _CgOnTapEffect({
    Key? key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 100),
    this.vibrate = false,
    this.behavior = HitTestBehavior.opaque,
    this.effects = const [
      CgOnTapEffectType.touchableOpacity,
    ],
    this.onLongPressed,
  }) : super(key: key);

  final Widget child;
  final List<CgOnTapEffectType> effects;
  final void Function()? onTap;
  final void Function()? onLongPressed;
  final Duration duration;
  final bool vibrate;
  final HitTestBehavior? behavior;

  @override
  _CgOnTapEffectState createState() => _CgOnTapEffectState();
}

class _CgOnTapEffectState extends State<_CgOnTapEffect> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final double scaleActive = 0.98;
  final double opacityActive = 0.2;

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 1, end: scaleActive).animate(controller);
    final animation2 = Tween<double>(begin: 1, end: opacityActive).animate(controller);

    void onTapCancel() => controller.reverse();
    void onTapDown() => controller.forward();
    void onTapUp() => controller.reverse().then((value) => widget.onTap!());

    if (widget.onTap != null) {
      return GestureDetector(
        behavior: widget.behavior,
        onLongPress: widget.onLongPressed != null ? widget.onLongPressed : null,
        onTapDown: (detail) => onTapDown(),
        onTapUp: (detail) => onTapUp(),
        onTapCancel: () => onTapCancel(),
        child: buildChild(controller, animation, animation2),
      );
    } else {
      return buildChild(controller, animation, animation2);
    }
  }

  AnimatedBuilder buildChild(
    AnimationController controller,
    Animation<double> animation,
    Animation<double> animation2,
  ) {
    return AnimatedBuilder(
      child: widget.child,
      animation: controller,
      builder: (context, child) {
        Widget result = child ?? const SizedBox();
        for (var effect in widget.effects) {
          switch (effect) {
            case CgOnTapEffectType.scaleDown:
              result = ScaleTransition(scale: animation, child: result);
              break;
            case CgOnTapEffectType.touchableOpacity:
              result = Opacity(opacity: animation2.value, child: result);
              break;
          }
        }
        return result;
      },
    );
  }
}
