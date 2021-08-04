import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class ModalFilter extends StatefulWidget {
  final String initialVal, title;
  final List<S2Choice<String>> options;
  final passVal;
  final String errorText;
  final bool error;

  // final ValueChanged onChange;
  ModalFilter(this.initialVal, this.title, this.options, this.passVal,this.errorText,this.error);

  @override
  _ModalFilter createState() => _ModalFilter(this.initialVal);
}

class _ModalFilter extends State<ModalFilter> {
  String value;

  _ModalFilter(this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0, style: BorderStyle.solid, color: widget.error ?Colors.red:Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            //
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0, style: BorderStyle.solid, color: widget.error ?Colors.red:Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: SmartSelect<String>.single(
                title: value.isEmpty?"Select option":value,
                value: value,
                onChange: (state) {
                  widget.passVal(state.value);
                  setState(() => value = state.value);
                },
                choiceItems: widget.options,
                modalTitle: widget.title,
                modalConfirm: false,
                modalType: S2ModalType.popupDialog,
                modalConfig: S2ModalConfig(
                  style: S2ModalStyle(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                choiceGrouped: false,
                modalFilter: true,
                modalFilterAuto: true,
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    hideValue: true,
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          child:
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15,top: 8),
              child: Text(
                widget.errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          visible: widget.error,
        ),
      ],
    );
  }
}
