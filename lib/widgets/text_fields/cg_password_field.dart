import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';

class CgPasswordField extends StatefulWidget {
  const CgPasswordField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  _CgPasswordFieldState createState() => _CgPasswordFieldState();
}

class _CgPasswordFieldState extends State<CgPasswordField> {
  late bool obscureText;

  @override
  void initState() {
    obscureText = true;
    super.initState();
  }

  String? get labelText => "ពាក្យសម្ងាត់";
  TextInputAction? get textInputAction => TextInputAction.go;
  TextInputType? get keyboardType => TextInputType.visiblePassword;

  @override
  Widget build(BuildContext context) {
    return CgTextField(
      labelText: labelText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscureText: obscureText,
      suffix: buildSuffix(),
    );
  }

  Widget? buildSuffix() {
    return IconButton(
      icon: AnimatedCrossFade(
        crossFadeState: obscureText ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: ConfigConstant.fadeDuration,
        secondChild: const Icon(Icons.visibility_off),
        firstChild: const Icon(Icons.visibility),
      ),
      onPressed: () {
        setState(() {
          this.obscureText = !obscureText;
        });
      },
    );
  }
}
