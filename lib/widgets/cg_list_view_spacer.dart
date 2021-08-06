import 'dart:math';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/widgets/cg_measure_size.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, Widget spacer);

class CgListViewSpacer extends StatefulWidget {
  const CgListViewSpacer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final WidgetBuilder builder;

  @override
  _CgListViewSpacerState createState() => _CgListViewSpacerState();
}

class _CgListViewSpacerState extends State<CgListViewSpacer> with CgMediaQueryMixin {
  late ValueNotifier<double> notifier;

  @override
  void initState() {
    notifier = ValueNotifier<double>(0);
    super.initState();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: ConfigConstant.layoutPadding.copyWith(
          top: ConfigConstant.objectHeight1,
          bottom: ConfigConstant.objectHeight1,
        ),
        physics: const ClampingScrollPhysics(),
        children: [
          CgMeasureSize(
            onChange: (Size size) {
              if (notifier.value > 0) return;
              double value = (mediaQueryData.size.height - size.height) / 2;
              value = max(0, value);
              value = min(64, value);
              notifier.value = value;
            },
            child: widget.builder(context, buildSpacer()),
          ),
        ],
      ),
    );
  }

  Widget buildSpacer() {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return SizedBox(
          height: notifier.value,
        );
      },
    );
  }
}
