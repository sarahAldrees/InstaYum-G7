import 'package:flutter/material.dart';
import 'package:instayum1/model/checkbox_state.dart';

//import 'checkboxState.dart';

class ConvertTocheckBox extends StatefulWidget {
  List<String> listOfin;
  String title;
  bool needConvert = true;
  List<CheckBoxState> listOfIngrediant = [];
  ConvertTocheckBox(this.listOfin, this.title);

  @override
  State<StatefulWidget> createState() => convert();
}

bool outvalue = false; //outvalue is change the state of check list
var checkedstyle = TextDecoration.none;

class convert extends State<ConvertTocheckBox> {
  @override
  Widget build(BuildContext context) {
    //-----------------to conviert String list to checkbox state---------------
    for (int i = 0; i < widget.listOfin.length; i++) {
      if (widget.needConvert)
        widget.listOfIngrediant.add(CheckBoxState(title: widget.listOfin[i]));
      else
        break;
    }
    //--------------------------------------------
    widget.needConvert = false;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          width: 380,
          decoration: BoxDecoration(
            color: Color(0xFFeb6d44),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                //backgroundColor: Colors.grey[50],
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        //-------------------to creat checkbox from checkbox state list-------------
        ...widget.listOfIngrediant.map(creatCheckbox).toList(),
      ],
    );
  }

//---------------------to creat checkbox list---------------
  Widget creatCheckbox(CheckBoxState checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Color(0xFFeb6d44),
      value: checkbox.outvalue,
      title: Text(checkbox.title,
          style: TextStyle(
            decoration: checkbox.checkedstyle,
            decorationColor: Color(0xFFeb6d44),
            decorationThickness: 4,
          )),
      onChanged: (value) {
        setState(() {
          checkbox.outvalue = value;
          if (checkbox.outvalue == true) {
            checkbox.checkedstyle = TextDecoration.lineThrough;
          } else {
            checkbox.checkedstyle = TextDecoration.none;
          }
        });
      });
}
