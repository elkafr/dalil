import 'package:flutter/material.dart';
import 'package:dalil/utils/app_colors.dart';




class DropDownListSelector extends StatefulWidget {
  final List<dynamic> dropDownList;
  final String hint;
  final dynamic value;
  final num marg;
  final Function onChangeFunc;



  const DropDownListSelector(
      {Key key,
      this.dropDownList,
      this.hint,
      this.value,
      this.marg,
      this.onChangeFunc,
     
     })
      : super(key: key);
  @override
  _DropDownListSelectorState createState() => _DropDownListSelectorState();
}

class _DropDownListSelectorState extends State<DropDownListSelector> {
  @override
  Widget build(BuildContext context) {
    
      return Container(

        height: 30,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03),
        margin:EdgeInsets.symmetric(
         horizontal: MediaQuery.of(context).size.width * widget.marg),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: hintColor),
          color: Colors.white,

        ),
        child: 
       DropdownButtonHideUnderline(

          child: DropdownButton<dynamic>(

            isExpanded: true,
            hint: Padding(
              padding: EdgeInsets.all(4),
              child: Text(
       widget.hint,
       style: TextStyle(
           color: Colors.black,
           fontSize: 12,
           fontWeight: FontWeight.w400,
           fontFamily: 'Cairo'),
              ),
            ),
            focusColor: mainAppColor,
            icon:Icon(
                   Icons.keyboard_arrow_down,
                   size: 20,
                   color: hintColor,
                 ),
            style: TextStyle(
         fontSize: 14,
         color: Colors.black,
         fontWeight: FontWeight.w400,
         fontFamily: 'Cairo'),
            items: widget.dropDownList,
            onChanged: widget.onChangeFunc,
            value: widget.value,

          ),
    ));

  }
}
