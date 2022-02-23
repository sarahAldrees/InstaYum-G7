import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    Key? key,
    this.hintText,
    this.selectedValue,
    this.onChanged,
    this.list = const [],
  }) : super(key: key);
  final List<String> list;
  String? selectedValue, hintText;
  final Function(String?)? onChanged;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            isDense: true,
            hint: Text(widget.hintText ?? 'Select'),
            value: widget.selectedValue != '' ? widget.selectedValue : null,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[700],
            ),
            iconSize: 30,
            underline: Container(
              height: 1,
              color: Colors.grey[700],
            ),
            onChanged: (String? newValue) {
              setState(() {
                widget.selectedValue = newValue;
              });
              if (widget.onChanged != null) widget.onChanged!(newValue);
            },
            style: TextStyle(color: AppColors.lightGrey),
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
