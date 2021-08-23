import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/widgets/text_fields/cg_text_field.dart';

class CgEmailField extends CgTextField {
  const CgEmailField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  String? get labelText => "អុីម៉េល";

  @override
  bool get autocorrect => false;

  @override
  TextInputAction? get textInputAction => TextInputAction.next;

  @override
  TextInputType? get keyboardType => TextInputType.emailAddress;
}
