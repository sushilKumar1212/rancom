import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';

Widget tapper({
  required VoidCallback? onPressed,
  required Widget child,
}) {
  return CupertinoButton(
    onPressed: onPressed,
    padding: EdgeInsets.zero,
    child: child,
  );
}

Widget myText(
  String text, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  int? maxLines,
  bool? underLine,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color ?? AppColors.black,
      fontSize: getFontSize(fontSize ?? 16),
      fontWeight: fontWeight ?? FontWeight.normal,
      decoration: underLine ?? false ? TextDecoration.underline : null,
    ),
    textAlign: textAlign ?? TextAlign.start,
    overflow: overflow ?? TextOverflow.visible,
    maxLines: maxLines,
  );
}

class CommonWidgets {
  static Widget textbox({
    String? hintText,
    String? labelText,
    FocusNode? focusNode,
    String? errorText,
    required TextEditingController controller,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatter,
    bool? obscureText,
    bool? enabled,
    bool? readOnly,
    bool? autofocus,
    int? maxLines,
    int? minLines,
    int? maxLength,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool showCountryCode = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            prefixIcon,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          if (showCountryCode)
            Row(
              children: [
                Text(
                  "+44",
                  style: TextStyle(fontSize: getFontSize(16)),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          Expanded(
            child: TextFormField(
              inputFormatters: formatter,
              focusNode: focusNode,
              validator: validator,
              controller: controller,
              textCapitalization: capitalization,
              keyboardType: keyboardType,
              obscureText: obscureText ?? false,
              enabled: enabled ?? true,
              readOnly: readOnly ?? false,
              autofocus: autofocus ?? false,
              maxLines: maxLines ?? 1,
              minLines: minLines ?? 1,
              maxLength: maxLength,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: hintText,
                labelText: labelText,
                errorText: errorText,
                hintStyle: const TextStyle(
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Show Message
void showMessage(String message, {Color? color}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: color,
  );
}

// Normal Textbox
Widget normalTextBox({
  VoidCallback? fullTap,
  bool readOnly = false,
  String? hintText,
  String? endText,
  Widget? endWidget,
  int? maxLength,
  List<TextInputFormatter>? formatter,
  FocusNode? focusNode,
  required TextEditingController controller,
  TextInputType? keyboardType,
  TextCapitalization capitalization = TextCapitalization.none,
  VoidCallback? onTap,
  bool enabled = true,
  Function(String)? onchange,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.grey,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: onchange,
            readOnly: readOnly,
            onTap: fullTap,
            inputFormatters: formatter,
            enabled: enabled,
            focusNode: focusNode,
            controller: controller,
            textCapitalization: capitalization,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.darkGrey,
                fontSize: getFontSize(16),
              ),
              counterText: "",
            ),
          ),
        ),
        SizedBox(
          width: getHorizontalSize(10),
        ),
        if (endWidget != null)
          endWidget
        else
          tapper(
            onPressed: onTap ?? () {},
            child: Text(
              endText ?? "",
              style: TextStyle(
                color: (endText == "Verified"
                    ? AppColors.darkGrey
                    : AppColors.primary),
              ),
            ),
          ),
      ],
    ),
  );
}

class StepProgressView extends StatelessWidget {
  final double _width;

  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = const Color(0xffE6EEF3);
  final double lineWidth = 3.0;

  const StepProgressView(
      {Key? key,
      required int curStep,
      required List<String> titles,
      required double width,
      required Color color})
      : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getHorizontalSize(35),
            ),
            child: Row(
              children: _iconViews(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _titleViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      var iconColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;

      list.add(
        Container(
          width: 25.0,
          height: 25.0,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
            border: Border.all(
              color: circleColor,
              width: 2.0,
            ),
          ),
          child: Center(
            child: i + 1 < _curStep
                ? const Icon(
                    Icons.check,
                    color: AppColors.black,
                    size: 20,
                  )
                : Text(
                    (i + 1).toString(),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(
          Expanded(
            child: Container(
              height: lineWidth,
              decoration: DottedDecoration(
                color: lineColor,
                dash: const [5, 3],
              ),
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(
        Text(
          text,
          style: TextStyle(
            color: AppColors.black,
            fontSize: getFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
    return list;
  }
}
