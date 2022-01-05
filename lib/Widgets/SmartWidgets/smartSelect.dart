import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class ModalFilter extends StatefulWidget {
  final String title, value, initialValue;
  final List<S2Choice<String>> options;
  final passVal;
  final String errorText;
  final bool error;
  final bool initial;
  final bool disableCancel;

  // final ValueChanged onChange;
  ModalFilter({
    this.value,
    this.title,
    this.options,
    this.passVal,
    this.errorText = "",
    this.error = false,
    this.initial = false,
    this.initialValue = "",
    this.disableCancel = false,
  });

  @override
  _ModalFilter createState() => _ModalFilter();
}

class _ModalFilter extends State<ModalFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: widget.error ? Colors.red : Colors.black,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  child: SmartSelect<String>.single(
                    title: widget.value.isEmpty
                        ? (widget.initial)
                            ? widget.initialValue
                            : "Select option"
                        : widget.value,
                    value: widget.value,
                    onChange: (state) => widget.passVal(state.value),
                    choiceItems: widget.options,
                    modalTitle: widget.title,
                    modalConfirm: true,
                    modalType: S2ModalType.popupDialog,
                    modalConfig: S2ModalConfig(
                      style: S2ModalStyle(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.0, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onTap: () => widget.passVal(""),
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ),
              visible: widget.value.isNotEmpty && !widget.disableCancel,
            ),
          ],
        ),
        Visibility(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                widget.errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          visible: widget.error,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
