// ignore_for_file: unnecessary_null_comparison, prefer_const_declarations, unnecessary_new, use_key_in_widget_constructors, unused_element, prefer_if_null_operators, use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field, must_be_immutable, prefer_const_constructors

import 'package:doc_expiry_app/util/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Upper menu
  Future<void> _selectMenu(String value) async {
    switch (value) {
      case menuDelete:
        if (widget.doc.id == -1) {
          return;
        }
        _deleteDoc(widget.doc.id);
    }
  }

  // Delete Doc
  void _deleteDoc(int id) async {
    int r = await widget.dbh.deleteDoc(widget.doc.id);
    Navigator.pop(context, true);
  }

  // Save Doc
  void _saveDoc() {
    widget.doc.title = titleCtrl.text;
    widget.doc.expiration = expirationCtrl.text;

    widget.doc.fqYear = Val.BoolToInt(fqYearCtrl);
    widget.doc.fqHalfYear = Val.BoolToInt(fqHalfYearCtrl);
    widget.doc.fqQuarter = Val.BoolToInt(fqQuarterCtrl);
    widget.doc.fqMonth = Val.BoolToInt(fqMonthCrtl);

    if (widget.doc.id > -1) {
      debugPrint("_update->Doc Id: " + widget.doc.id.toString());
      widget.dbh.updateDoc(widget.doc);
      Navigator.pop(context, true);
    } else {
      Future<int?> idd = widget.dbh.getMaxId();
      idd.then((result) {
        debugPrint("_insert->DocId: " + widget.doc.id.toString());
        widget.doc.id = (result != null) ? result + 1 : 1;
        widget.dbh.insertDoc(widget.doc);
        Navigator.pop(context, true);
      });
    }
  }

  // Submit form
  void _submitForm() {
    final FormState? form = _formKey.currentState;

    if (!form!.validate()) {
      showMessage(context, "Some data is invalid. Please Correct.");
    } else {
      _saveDoc();
    }
  }

  void showMessage(BuildContext context, String message,
      [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _initCtrls();
  }

// UI for DocDetail
  @override
  Widget build(BuildContext context) {
    const String cStrDays = "Enter a number of Days";
    TextStyle? tStyle = Theme.of(context).textTheme.titleLarge;
    String ttl = widget.doc.title;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(ttl != "" ? widget.doc.title : "New Document"),
        actions: (ttl == "")
            ? <Widget>[]
            : <Widget>[
                PopupMenuButton(
                  onSelected: _selectMenu,
                  itemBuilder: (BuildContext context) {
                    return menuOptions.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  // Use FilteringTextInputFormatter.allow instead of WhitelistingTextInputFormatter
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0_9 ]"))
                ],
                controller: titleCtrl,
                style: tStyle,
                validator: (val) => Val.ValidateTitle(val!),
                decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: "Enter the document name",
                    labelText: "Document Name"),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: expirationCtrl,
                      maxLength: 10,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: "Expiry date (i.e. " +
                            utils.DateUtils.daysAheadAsStr(daysAhead) +
                            ")",
                        labelText: "Expiry Date",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => utils.DateUtils.isValidDate(val!)
                          ? null
                          : "Not a valid future date",
                    ),
                  ),
                  IconButton(
                    icon: new Icon(Icons.more_horiz),
                    tooltip: "Choose date",
                    onPressed: (() {
                      _chooseDate(context, expirationCtrl.text);
                    }),
                  ),
                ],
              ),
              const Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
              Row(children: <Widget>[
                const Expanded(child: Text("a: Alert @ 1.5 & 1 year(s)")),
                Switch(
                    value: fqYearCtrl,
                    onChanged: (bool value) {
                      setState(() {
                        fqYearCtrl = value;
                      });
                    })
              ]),
              Row(children: <Widget>[
                const Expanded(child: Text("b: Alert @ 3 Months")),
                Switch(
                    value: fqHalfYearCtrl,
                    onChanged: (bool value) {
                      setState(() {
                        fqHalfYearCtrl = value;
                      });
                    })
              ]),
              Row(children: <Widget>[
                const Expanded(child: Text("c: Alert @ 3 Months")),
                Switch(
                    value: fqQuarterCtrl,
                    onChanged: (bool value) {
                      setState(() {
                        fqQuarterCtrl = value;
                      });
                    })
              ]),
              Row(children: <Widget>[
                const Expanded(child: Text("s: Alert @ 1 Month or less")),
                Switch(
                    value: fqMonthCrtl,
                    onChanged: (bool value) {
                      setState(() {
                        fqMonthCrtl = value;
                      });
                    })
              ]),
              Container(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Save"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
