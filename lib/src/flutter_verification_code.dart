import 'package:flutter/material.dart';

class VerificationCode extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final TextInputType keyboardType;
  final int length;
  final Color underlineColor;
  final TextStyle textStyle;
  final bool autofocus;
  final double maxWidth;

  VerificationCode({
    Key key,
    @required this.onCompleted,
    this.maxWidth = double.infinity,
    this.keyboardType = TextInputType.number,
    this.length = 4,
    this.underlineColor,
    this.textStyle = const TextStyle(fontSize: 25.0),
    this.autofocus = false,
  })  : assert(length > 0),
        assert(onCompleted != null),
        super(key: key);

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  static final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<TextEditingController> _listControllerText =
      <TextEditingController>[];
  List<String> _code = List();
  int _currentIndex = 0;

  @override
  void initState() {
    _listFocusNode.clear();
    for (var i = 0; i < widget.length; i++) {
      _listFocusNode.add(FocusNode());
      _listControllerText.add(TextEditingController());
      _code.add('');
    }
    super.initState();
  }

  String _getInputVerify() {
    String verifyCode = "";
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != "") {
          verifyCode += _listControllerText[i].text[index];
        }
      }
    }
    return verifyCode;
  }

  Widget _buildInputItem(int index) {
    return TextField(
      keyboardType: widget.keyboardType,
      maxLines: 1,
      maxLength: 1,
      controller: _listControllerText[index],
      focusNode: _listFocusNode[index],
      showCursor: true,
      maxLengthEnforced: true,
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: widget.autofocus,
      style: widget.textStyle,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        counterText: "",
        errorMaxLines: 1,
      ),
//      textInputAction: TextInputAction.previous,
      onChanged: (String value) {
        if (value.length > 0 && index < widget.length ||
            index == 0 && value.isNotEmpty) {
          if (index == widget.length - 1) {
            widget.onCompleted(_getInputVerify());
            return;
          }
          if (_listControllerText[index + 1].value.text.isEmpty) {
            _listControllerText[index + 1].value = TextEditingValue(text: "");
          }
          if (index < widget.length - 1) {
            _next(index);
          }

          return;
        }
        if (value.length == 0 && index >= 0) {
          _prev(index);
        }
      },
    );
  }

  void _next(int index) {
    if (index != widget.length - 1) {
      setState(() {
        _currentIndex = index + 1;
      });
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {}
        _currentIndex = index - 1;
      });
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = List();
    for (int index = 0; index < widget.length; index++) {
      listWidget.add(
        Container(
          decoration: index != widget.length - 1
              ? BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                )
              : null,
          // border: Border.all(color: Colors.red)),
          height: 28.0,
          width: ((widget.maxWidth - 14.0) / widget.length),
          child: _buildInputItem(index),
        ),
      );
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildListWidget(),
        ),
      ),
    );
  }
}
