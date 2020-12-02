import 'package:doctracking/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../../src/blocs/date_picker/date_picker.dart';
import '../../src/blocs/doc_form/doc_form.dart';
import '../../src/util/date_util.dart';

class NewDoc extends StatefulWidget {
  @override
  _NewDocState createState() => _NewDocState();
}

class _NewDocState extends State<NewDoc> {
  final _titleController = TextEditingController();
  final _expiryDateController = MaskedTextController(mask: '2000-00-00');

  bool notifyAtOneYearMark = true;
  bool notifyAtHalfYearMark = true;
  bool notifyAtQuarterMark = true;
  bool notifyAtMonthMark = true;

  final GlobalKey<FormState> _docFormKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  DatePickerBloc _datePickerBloc;
  DocFormBloc _docFormBloc;

  final int daysAhead = 5475;

  @override
  void initState() {
    _docFormBloc = BlocProvider.of<DocFormBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('New Doc'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(child: _buildDocForm()));
  }

  Widget _buildDocForm() {
    return BlocBuilder<DocFormBloc, DocState>(builder: (context, state) {
      if (state is DocumentFormSubmissionFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showMessage(state.error, Colors.red);
        });
      }
      if (state is DocumentFormSubmissionSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showMessage(
              '${state.doc.title} is being uploaded to the web', Colors.green);
        });
      }
      if (state is DocumentFormSubmissionLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showMessage('loading', Colors.white);
          return CircularProgressIndicator();
        });
      }
      return Form(
          autovalidate: true,
          key: _docFormKey,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  ],
                  controller: _titleController,
                  validator: (value) => Validate.validateTitle(value),
                  decoration: InputDecoration(
                      labelText: 'doc name',
                      hintText: 'enter doc name',
                      icon: const Icon(Icons.title)),
                ),
                BlocProvider(
                  create: (BuildContext context) => DatePickerBloc(),
                  child: BlocBuilder<DatePickerBloc, DatePickerState>(
                      builder: (context, state) {
                    if (state is DatePickerInitial) _chooseDate(context);
                    if (state is DatePickerDatePickSuccess)
                      _expiryDateController.text = state.expirationDate;
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _expiryDateController,
                              validator: (expiryDate) =>
                                  DateUtils.isValidDate(expiryDate)
                                      ? null
                                      : 'invalid date',
                              decoration: InputDecoration(
                                  hintText: 'expiry date(i.e.' +
                                      DateUtils.daysAheadAsStr(daysAhead) +
                                      ')',
                                  labelText: 'expiry date'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.more_horiz),
                              tooltip: 'pick date',
                              onPressed: () => _datePickerBloc =
                                  BlocProvider.of<DatePickerBloc>(context)
                                    ..add(DatePickerButtonPressed())),
                        ]);
                  }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('a: alert @ 1 year'),
                    ),
                    Switch(
                        value: notifyAtOneYearMark,
                        onChanged: (bool value) => notifyAtOneYearMark = value)
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('a: alert @ 6 months'),
                    ),
                    Switch(
                        value: notifyAtHalfYearMark,
                        onChanged: (bool value) => notifyAtHalfYearMark = value)
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('a: alert @ quarter year'),
                    ),
                    Switch(
                        value: notifyAtQuarterMark,
                        onChanged: (bool value) => notifyAtQuarterMark = value)
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('a: alert @ one month mark'),
                    ),
                    Switch(
                        value: notifyAtMonthMark,
                        onChanged: (bool value) => notifyAtMonthMark = value)
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                    child: Text('save'),
                    onPressed: () {
                      var doc = Doc(
                        title: _titleController.text.toString(),
                        expiration: _expiryDateController.text.toString(),
                        notifyAtQuarterMark:
                            Validate.boolToInt(notifyAtQuarterMark),
                        notifyAtOneYearMark:
                            Validate.boolToInt(notifyAtOneYearMark),
                        notifyAtMonthMark:
                            Validate.boolToInt(notifyAtMonthMark),
                        notifyAtHalfYearMark:
                            Validate.boolToInt(notifyAtHalfYearMark),
                      );
                      _docFormBloc.add(DocFormSaveButtonPressed(
                          doc: doc, formKey: _docFormKey));
                    }),
              ],
            ),
          ));
    });
  }

  _chooseDate(BuildContext context) async {
    debugPrint("Picker is pressed");
    var now = DateTime.now();
    debugPrint("$now");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DatePicker.showDatePicker(context, showTitleActions: true,
          onConfirm: (date) {
        _datePickerBloc.add(DatePickerDoneButtonPressed(
            expirationDate: DateUtils.ftDateAsStr(date)));
      }, currentTime: now);
    });
  }

  void _showMessage(String message, Color color) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }
}
