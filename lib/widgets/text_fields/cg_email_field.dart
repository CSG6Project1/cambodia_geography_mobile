import 'package:cambodia_geography/exports/exports.dart';
import 'package:easy_localization/easy_localization.dart';

class CgEmailField extends CgTextField {
  const CgEmailField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  String? get labelText => tr('hint.email');

  @override
  bool get autocorrect => false;

  @override
  TextInputAction? get textInputAction => TextInputAction.next;

  @override
  TextInputType? get keyboardType => TextInputType.emailAddress;
}
