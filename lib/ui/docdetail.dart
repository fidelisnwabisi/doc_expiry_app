import 'package:doc_expiry_app/util/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../model/model.dart';
import '../util/dbhelper.dart';
import '../util/utils.dart';

const menuDelete = "Delete";
final List<String> menuOptions = const <String>[menuDelete];

class DocDetail extends StatefulWidget {
  Doc doc;
  final DbHelper dbh = DbHelper();
  DocDetail(this.doc);

  @override
  State<StatefulWidget> createState() => DocDetailState();
}

class DocDetailState extends State<DocDetail> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final int daysAhead = 5475; // 15 years in the future

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController expirationCtrl =
      MaskedTextController(mask: "2000-00-00");

  bool fqYearCtrl = true;
  bool fqHalfYearCtrl = true;
  bool fqQuarterCtrl = true;
  bool fqMonthCrtl = true;
  bool fqLessMonthCtrl = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // Initialization code
  void _initCtrls() {
    titleCtrl.text = widget.doc.title != null ? widget.doc.title : "";
    expirationCtrl.text =
        widget.doc.expiration != null ? widget.doc.expiration : "";

    fqYearCtrl =
        widget.doc.fqYear != null ? Val.IntToBool(widget.doc.fqYear) : false;
    fqHalfYearCtrl = widget.doc.fqHalfYear != null
        ? Val.IntToBool(widget.doc.fqHalfYear)
        : false;
    fqQuarterCtrl = widget.doc.fqQuarter != null
        ? Val.IntToBool(widget.doc.fqQuarter)
        : false;
    fqMonthCrtl =
        widget.doc.fqMonth != null ? Val.IntToBool(widget.doc.fqMonth) : false;
  }

  // Date Picker & Date Function
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = utils.DateUtils.convertToDate(initialDateString) ?? now;

    initialDate = (initialDate.year >= now.year && initialDate.isAfter(now)
        ? initialDate
        : now);

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        DateTime dt = date;
        String r = utils.DateUtils.ftDateAsStr(dt);
        expirationCtrl.text = r;
      });
    }, currentTime: initialDate);
  }
}
